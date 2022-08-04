from django.shortcuts import render

# Create your views here.
# Views can be created with functions or classes
def index(request):
    return render(request, 'index.html')

def about(request):
    return render(request, 'about.html')