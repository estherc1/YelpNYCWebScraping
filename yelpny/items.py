# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class YelpnyItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    name = scrapy.Field()
    stars = scrapy.Field()
    no_reviews = scrapy.Field()
    no_photos = scrapy.Field()
    price_range = scrapy.Field()
    cuisine1 = scrapy.Field()
    cuisine2 = scrapy.Field()
    cuisine3 = scrapy.Field()
    phone = scrapy.Field()
    address = scrapy.Field()
    neighborhood = scrapy.Field()
    reservation = scrapy.Field()
    takeout = scrapy.Field()
    delivery = scrapy.Field()
    quote1 = scrapy.Field()
    quote2 = scrapy.Field()
    quote3 = scrapy.Field()
    firstreviewdate = scrapy.Field()


