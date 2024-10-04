from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token
from . import views

urlpatterns = [
    path('api-token-auth/', obtain_auth_token),
    
    path('', views.getRoutes),
    path('foods/', views.getAllOrCreateFoods),
    path('foods/<str:pk>', views.getAndUpdateFood),
    path('entry/<str:pk>', views.updateEntry),

]