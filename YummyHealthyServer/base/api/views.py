from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from base.models import Food, ServingSizeOption, Entry
from .serializers import FoodSerializer, ServingSizeOptionSerializer, EntrySerializer

@api_view(['GET'])
def getRoutes(request):
    routes = [
        'GET /api',
        'GET /api/foods',
        'GET /api/foods/:id',
    ]
    return Response(routes)

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def getAllOrCreateFoods(request):
    if request.method == 'GET':
        foods = request.user.food_set.prefetch_related('servingSizeOptions').all()
        serializer = FoodSerializer(foods, many=True)
        return Response(serializer.data)
    elif request.method == 'POST':
        
        foodSerializer = FoodSerializer(data=request.data)
        servingSizeOptionData = request.data['servingSizeOptions']
        servingSizeOptionSerializer = ServingSizeOptionSerializer(data=servingSizeOptionData, many=True)
        entryData = request.data['entries']
        entrySerializer = EntrySerializer(data=entryData, many=True, partial=True)
        
        if foodSerializer.is_valid() and servingSizeOptionSerializer.is_valid() and entrySerializer.is_valid():
            foodSerializer.save(user=request.user)
            servingSizeOptionSerializer.save(food=foodSerializer.instance)
            entrySerializer.save(food=foodSerializer.instance)
            return Response(foodSerializer.data, status=status.HTTP_201_CREATED)
        return Response(foodSerializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getFoods(request):
    foods = request.user.food_set.prefetch_related('servingSizeOptions').all()
    serializer = FoodSerializer(foods, many=True)
    return Response(serializer.data)

@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticated])
def getAndUpdateFood(request, pk):
    if request.method == 'GET':
        foods = request.user.food_set.prefetch_related('servingSizeOptions').get(id=pk)
        serializer = FoodSerializer(foods, many=False)
        return Response(serializer.data)
    elif request.method == 'PUT':
        food = Food.objects.get(id=pk)
        serializer = FoodSerializer(instance=food, data=request.data, partial=True)

        if 'servingSizeOptions' in request.data:
            optionsData = request.data['servingSizeOptions']
            optionsSerializer = ServingSizeOptionSerializer(data=optionsData, many=True)
            if optionsSerializer.is_valid():
                for option in food.servingSizeOptions.all():
                    option.delete()
                optionsSerializer.save(food=food)
            else:  
                return Response(optionsSerializer.errors, status=status.HTTP_400_BAD_REQUEST)
        

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def createFoods(request):
    serializer = FoodSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def deleteFoods(request, pk):
    food = Food.objects.get(id=pk)
    food.delete()
    return Response("Item deleted successfully", status=status.HTTP_204_NO_CONTENT)

@api_view(['PUT', 'DELETE'])
@permission_classes([IsAuthenticated])
def updateEntry(request, pk):
    entry = Entry.objects.get(id=pk)
    if request.method == 'PUT':
        serializer = EntrySerializer(instance=entry, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            if 'consumeTime' in request.data:
                entry.consumeTime = request.data['consumeTime']
            entry.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    elif request.method == 'DELETE':
        entry.delete()
        return Response("Item deleted successfully")
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)