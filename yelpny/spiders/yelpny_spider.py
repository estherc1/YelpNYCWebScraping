from scrapy import Spider, Request
from yelpny.items import YelpnyItem
import re

class YelpnySpider(Spider):
	name = 'yelpny_spider'
	allowed_urls = ['https://www.yelp.com/']
	start_urls = ['https://www.yelp.com/search?find_desc=Restaurants&find_loc=Manhattan%2C+NY']

	def parse(self, response):

		# Find the total number of pages in the result so that we can decide how many urls to scrape next
		number_pages = response.xpath('//div[@class="pagination-block"]/div/div/text()').extract_first().strip().strip('Page 1 of ')

		# except:
			# number_pages = 1

		# List comprehension to construct all the urls
		result_urls = ['https://www.yelp.com/search?find_desc=Restaurants&find_loc=Manhattan,+NY&start={}'.format(30*x) for x in range(int(number_pages))]

		# Yield the requests to different search result urls, 
		# using parse_result_page function to parse the response.
		for url in result_urls:
			yield Request(url=url, callback=self.parse_result_page)

	def parse_result_page(self, response):
		# This fucntion parses the search result page.
		
		# We are looking for url of the detail page.
		details = response.xpath('//span/a[@class="biz-name js-analytics-click"]/@href').extract()
		# List comprehension to construct all the urls
		detail_urls = ['https://www.yelp.com{}sort_by=date_asc'.format(x.strip('osq=Restaurants')) for x in details]

		# Yield the requests to the details pages, 
		# using parse_detail_page function to parse the response.
		for url in detail_urls:
			yield Request(url=url, callback=self.parse_detail_page)

	def parse_detail_page(self, response):
		# This fucntion parses the product detail page.

		name = response.xpath('//div[@class="biz-page-header clearfix"]/div/div/h1/text()').extract_first().strip()
		stars = response.xpath('//div[@class="rating-info clearfix"]/div/div/@title').extract_first().strip(' star rating')
		no_reviews = response.xpath('//div[@class="rating-info clearfix"]/div/span/text()').extract_first().strip().strip(' reviews')
		
		if response.xpath('//div[@class="js-photo photo photo-3 photo-grid"]/a/text()') != []:
			no_photos = response.xpath('//div[@class="js-photo photo photo-3 photo-grid"]/a/text()').extract()[1].strip().strip('See all ').strip(' photos')
		elif len(response.xpath('//*[@id="wrap"]/div[2]/div/div[1]/div/div[4]/div[2]/div/div[2]/a/text()').extract()) == 2: 
			no_photos = response.xpath('//*[@id="wrap"]/div[2]/div/div[1]/div/div[4]/div[2]/div/div[2]/a/text()').extract()[1].strip().strip('See all ').strip(' photos')
		else:
			no_photos = response.xpath('//*[@id="wrap"]/div[2]/div/div[1]/div/div[4]/div[2]/div/div[2]/a/text()').extract()[3].strip().strip('See all ').strip(' photos')

		price_range = response.xpath('//div[@class="biz-main-info embossed-text-white"]/div/span/span/text()').extract_first()

		# List of all types of cuisine and allocate
		cuisine = response.xpath('//div[@class="biz-main-info embossed-text-white"]/div/span/a/text()').extract()
		no_types = len(cuisine)
		cuisine1 = cuisine[0]
		if no_types > 1:
			cuisine2 = cuisine[1]
			if no_types >2:
				cuisine3 = cuisine[2]
			else:
				cuisine3 = ''
		else:
			cuisine2 = ''
			cuisine3 = ''

		phone = response.xpath('//span[@class="biz-phone"]/text()').extract_first().strip()
		address = ', '.join(response.xpath('//strong[@class="street-address"]/address/text()').extract()).strip()
		neighborhood = response.xpath('//span[@class="neighborhood-str-list"]/text()').extract_first().strip()

		if response.xpath('//h3[@class="reservations-title reservation-header-black"]') != []:
			reservation = True
		else:
			reservation = False

		deliv_takeout = response.xpath('//div[@class="js-make-order"]/form/div/label/span/text()').extract()
		if deliv_takeout == []:
			delivery = False
			takeout = False
		elif len(deliv_takeout) == 1:
			if deliv_takeout[0] == 'Delivery':
				delivery = True
				takeout = False
			else:
				delivery = False
				takeout = True
		else:
			delivery = True
			takeout = True

		quotes_key = response.xpath('//div[@class="media-story"]/p/a[@class="ngram"]//text()').extract()
		quotes = response.xpath('//div[@class="media-story"]/p/text()').extract()
		quotes = [x.strip() for x in quotes]
		for i in range(len(quotes)-6):
			try: 
				quotes.remove('')
			except:
				pass
		if len(quotes_key) == 3:
			quote1 = quotes[0].strip()+' '+quotes_key[0]+' '+quotes[1].strip()
			quote2 = quotes[2].strip()+' '+quotes_key[1]+' '+quotes[3].strip()
			quote3 = quotes[4].strip()+' '+quotes_key[2]+' '+quotes[5].strip()
		else:
			quote1, quote2, quote3 = '', '', ''
		firstreviewdate = response.xpath('//span[@class="rating-qualifier"]/text()').extract_first().strip()


		item = YelpnyItem()
		item['name'] = name
		item['stars'] = float(stars)
		item['no_reviews'] = int(no_reviews)
		item['no_photos'] = int(no_photos)
		item['price_range'] = price_range
		item['cuisine1'] = cuisine1
		item['cuisine2'] = cuisine2
		item['cuisine3'] = cuisine3
		item['phone'] = phone
		item['address'] = address
		item['neighborhood'] = neighborhood
		item['reservation'] = reservation
		item['delivery'] = delivery
		item['takeout'] = takeout
		item['quote1'] = quote1
		item['quote2'] = quote2
		item['quote3'] = quote3
		item['firstreviewdate'] = firstreviewdate

		yield item    
