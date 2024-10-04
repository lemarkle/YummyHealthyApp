import uuid
from django.db import models
from django.contrib.auth.models import AbstractUser

# Create your models here.
class User(AbstractUser):
    
    name = models.CharField(max_length=200, null=True)
    email = models.EmailField(unique=True, null=True)
    # avatar = models.ImageField(null=True, default="avatar.svg")
    caloriesGoal = models.IntegerField()
    proteinsGoal = models.IntegerField()
    carbohydratesGoal = models.IntegerField()
    fatGoal = models.IntegerField()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

class Food(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=200, null=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    calories = models.IntegerField()
    proteins = models.IntegerField()
    carbohydrates = models.IntegerField()
    fat = models.IntegerField()


    def __str__(self):
        return self.name
    
class Entry(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    consumeTime= models.DateTimeField(auto_now_add=True)
    numServing = models.IntegerField()
    servingSizeOption = models.CharField(max_length=50, null=True)
    servingSizeOptionMultiplier = models.FloatField()
    food = models.ForeignKey(Food, related_name='entries', on_delete=models.CASCADE)
    
    
    def __str__(self):
        return self.consumeTime.strftime("%Y-%m-%d %H:%M:%S")
    
class ServingSizeOption(models.Model):
    value = models.CharField(max_length=50, null=True)
    multiplier = models.FloatField()
    food = models.ForeignKey(Food, related_name='servingSizeOptions', on_delete=models.CASCADE)

    def __str__(self):
        return self.value
    