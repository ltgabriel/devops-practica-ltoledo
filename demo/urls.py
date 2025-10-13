from django.contrib import admin
from django.urls import path, include
from django.http import HttpResponse
def home(request):
    return HttpResponse("Proyecto de lorenzo DevOps Django funcionando!")

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('api.urls'))
]
