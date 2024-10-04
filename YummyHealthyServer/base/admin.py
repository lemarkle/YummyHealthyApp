from django.contrib import admin

# Register your models here.

from .models import Food, User, ServingSizeOption, Entry

admin.site.register(Food)
admin.site.register(User)
admin.site.register(ServingSizeOption)
admin.site.register(Entry)