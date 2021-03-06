div = -> $('<div>')
box = (id) -> div().addClass('box').attr('id', id)
reading = (text) -> div().addClass('reading').text(text)
label = (text) -> div().addClass('labels').text(text)
title = (text) -> div().addClass('title').text(text)
reading = (text) -> div().addClass('reading').text(text)

siteId = parseInt document.location.hash.replace('#', '')

errorListings = div().addClass('listing')
perfListings = div().addClass('listing')

pageCountReading = reading(0)
errorCountReading = reading(0)
remainingPagesCountReading = reading(0)
rootUrl = div()
startButton = title('start')

rootUrlHolder = box('root-url').append(rootUrl)
pageCountHolder = box('page-count').append(pageCountReading).append(label('pages'))
errorCountHolder = box('error-count').append(errorCountReading).append(label('errors'))
responseTimeHolder = box('response-time').append(reading(0)).append(label('response time (ms)'))
errorListHolder = box('error-list').append(title('errors')).append(errorListings)
perfListHolder = box('perf-list').append(title('performance')).append(perfListings)
runButtonHolder = box('run-button').append(startButton).append(remainingPagesCountReading).append(label('pages remaining'))

startButton.click -> $.getJSON "/sites/#{siteId}/start"

updateData = (data) ->    
  rootUrl.html(data.root)
  pageCountReading.text(data.page_count)
  errorCountReading.text(data.errors.length)
  remainingPagesCountReading.text(data.pages_remaining_count)
  errorListings.empty()
  $.each data.errors, (index, error) -> errorListings.append($('<a>').attr('href', error.url).text(error.path).attr('target', '_blank'))
  

fetchData = ->
  $.getJSON("/sites/#{siteId}").success (data) -> updateData(data)


infoConfig = {
  grid: {
    rows: 10
    columns: 12
    margin: 0.618
  }
  elements: [
    {
      view: pageCountHolder
      height: 3
      width: 4
      position: {x: 0, y: 0}
    }
    {
      view: errorCountHolder
      height: 3
      width: 4
      position: {x: 4, y: 0}
    }
    {
      view: responseTimeHolder
      height: 3
      width: 4
      position: {x: 8, y: 0}
    }
    {
      view: errorListHolder
      height: 6
      width: 5
      position: {x: 2, y: 3}
    }
    {
      view: perfListHolder
      height: 6
      width: 5
      position: {x: 7, y: 3}
    }
    {
      view: runButtonHolder
      height: 7
      width: 2
      position: {x: 0, y: 3}
    }
    {
      view: rootUrlHolder
      height: 1
      width: 10
      position: {x: 2, y: 9}
    }
  ]
}


$ -> 
  metro = new MetroMan $('#container')
  metro.load infoConfig
  setInterval fetchData, 1000