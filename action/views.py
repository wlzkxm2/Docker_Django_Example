from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from rest_framework.views import APIView, Response
from rest_framework import permissions
from .models import Project
from .serializers import ProjectSerializer
from rest_framework.decorators import action


# Create your views here.
class TestView(ModelViewSet) :
    queryset = Project.objects.all()
    serializer_class = ProjectSerializer
    permission_classes = [permissions.AllowAny]
    
    @action(detail=False, methods=["GET"])
    def ProjectList(self, request):
        try :
            proj_list_serilizer = self.serializer_class(self.queryset, many=True)
            
            return Response(data=proj_list_serilizer.data, status=200)
        except Exception as e :
            return Response(data={
                "result" : False,
                "data" :  e
            },status= 400)