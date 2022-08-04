from distutils.command.clean import clean
from unicodedata import name
from django.db import models

# Create your models here.
# Models = Tables, fields = Columns in database terminology
# Model fields cheat sheet https://www.youtube.com/watch?v=yxpR3Qtx4Uk&list=PLlrxD0HtieHjHCQ0JB_RrhbQp_9ccJztr&index=7

class Destination(models.Model):
    name = models.CharField(
        unique=True, # Name of the Destination should be unique among other names
        null=False, # It always has to be set, Entry can not be empty.
        blank=False, # No empty string allowed.
        max_length=50
    )
    description = models.TextField(
        max_length=2000, #Length of description.
        null=False,
        blank=False
    )
    slug = models.SlugField()
    def __str__(self) -> str: # Called magic or dunder methods, will return name of object if called
        return self.name

class Cruise(models.Model):
    name = models.CharField(
        unique=True, # Name of the Destination should be unique among other names
        null=False, # It always has to be set, Entry can not be empty.
        blank=False, # No empty string allowed.
        max_length=50
    )
    description = models.TextField(
        max_length=2000, #Length of description.
        null=False,
        blank=False
    )
    destinations = models.ManyToManyField ( 
        #ManytoMany because destinations can have more than one cruise visiting, same as one cruise can go to multiple destinations
        Destination,
        related_name='destinations'

    )
    def __str__(self) -> str: # Called magic or dunder methods, will return name of object if called
        return self.name