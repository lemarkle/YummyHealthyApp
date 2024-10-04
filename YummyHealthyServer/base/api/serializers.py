from rest_framework import serializers
from rest_framework.serializers import ModelSerializer
from base.models import Food, ServingSizeOption, Entry

class ServingSizeOptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = ServingSizeOption
        fields = ['value', 'multiplier']

class EntrySerializer(serializers.ModelSerializer):
    consumeTime = serializers.DateTimeField(format="%Y-%m-%dT%H:%M:%S.%fZ")
    class Meta:
        model = Entry
        fields = ['id', 'consumeTime', 'numServing', 'servingSizeOption', 'servingSizeOptionMultiplier']

class FoodSerializer(ModelSerializer):
    servingSizeOptions = ServingSizeOptionSerializer(many=True, read_only=True)
    entries = EntrySerializer(many=True, read_only=True)

    class Meta:
        model = Food
        fields = ['id', 'name', 'calories', 'proteins', 'carbohydrates', 'fat',  'servingSizeOptions', 'entries']
