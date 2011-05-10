from django.conf.urls.defaults import patterns, url

urlpatterns = patterns('',
    url('^$', 'myshop.views.index'),
)
