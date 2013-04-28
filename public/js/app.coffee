div = -> $('<div>')
box = (id) -> div().addClass('box').attr('id', id)
reading = (text) -> div().addClass('reading').text(text)
label = (text) -> div().addClass('labels').text(text)
title = (text) -> div().addClass('title').text(text)
reading = (text) -> div().addClass('reading').text(text)

pageCountHolder = box('page-count').append(reading(125348)).append(label('pages'))
errorCountHolder = box('error-count').append(reading(17)).append(label('errors'))
responseTimeHolder = box('response-time').append(reading(345)).append(label('response time (ms)'))
errorListHolder = box('error-list').append(title('errors')).append(div().addClass('listing'))
perfListHolder = box('perf-list').append(title('performance')).append(div().addClass('listing'))
runButtonHolder = box('run-button').append(title('start')).append(reading('34.5%'))

infoConfig = {
  grid: {
    rows: 5
    columns: 12
    margin: 0.618
  }
  elements: [
    {
      view: pageCountHolder
      height: 2
      width: 4
      position: {x: 0, y: 0}
    }
    {
      view: errorCountHolder
      height: 2
      width: 4
      position: {x: 4, y: 0}
    }
    {
      view: responseTimeHolder
      height: 2
      width: 4
      position: {x: 8, y: 0}
    }
    {
      view: errorListHolder
      height: 3
      width: 5
      position: {x: 2, y: 2}
    }
    {
      view: perfListHolder
      height: 3
      width: 5
      position: {x: 7, y: 2}
    }
    {
      view: runButtonHolder
      height: 3
      width: 2
      position: {x: 0, y: 2}
    }
  ]
}


$ -> 
  metro = new MetroMan $('#container')
  metro.load infoConfig