
class D3Component
	selector: '#d3-window'
	$el: null

	numberOfLayers: 20
	numberOfSamples: 200
	layers0: null
	layers1: null

	windowWidth: 960
	windowHeight: 500

	graphX: null
	graphY: null

	color: null
	area: null

	svg: null

	durationTime: 2500

	constructor: ->
		@$el = $( @selector )
		@init()
		@initSVG()

	init: ->
		stack = window.d3.layout.stack().offset("wiggle")
		@layers0 = stack( window.d3.range( @numberOfLayers ).map( =>
			@bumpLayer()
		) )
		@layers1 = stack( window.d3.range( @numberOfLayers ).map( =>
			@bumpLayer()
		) )

		@graphX = window.d3.scale.linear()
			.domain( [0, @numberOfSamples - 1] )
			.range( [0, @windowWidth] )
		getMaxY = =>
			window.d3.max( @layers0.concat( @layers1 ), (layer) ->
				return window.d3.max( layer, (d) ->
					return d.y0 + d.y
				)
			)
		@graphY = window.d3.scale.linear()
			.domain( [0, getMaxY() ] )
			.range( [@windowHeight, 0] )

		@color = window.d3.scale.linear()
			.range( ['#aad', '#556'] )

		@area = window.d3.svg.area()
			.x( (d) => @graphX( d.x ) )
			.y0( (d) => @graphY( d.y0 ) )
			.y1( (d) => @graphY( d.y0 + d.y ) )

	initSVG: ->
		@svg = window.d3.selectAll( @$el ).append('svg')
			.attr( 'width', @windowWidth )
			.attr( 'height', @windowHeight )

		@svg.selectAll('path')
			.data( @layers0 )
			.enter().append('path')
			.attr('d', @area)
			.style( 'fill', => @color( Math.random() ) )

	transition: ->
		window.d3.selectAll('path')
			.data( =>
				d = @layers1
				@layers1 = @layers0
				@layers0 = d
			)
			.transition()
			.duration( @durationTime )
			.attr( 'd', @area )

	_bump: (array) ->
		x = 1 / ( .1 + Math.random() )
		y = 2 * Math.random() - .5
		z = 10 / ( .1 + Math.random() )
		for i in [0...@numberOfSamples]
			w = (i / @numberOfSamples - y) * z
			array[i] += x * Math.exp( -w * w )

	bumpLayer: () ->
		array = []
		for i in [0...@numberOfSamples]
			array[i] = 0
		for i in [0...5]
			@_bump( array )
		return array.map( (d, i) -> { x: i, y: Math.max( 0, d ) } )

class App
	run: ->
		$(document).ready ->
			@d3Component = new D3Component()
			$('[js-update]').on 'click', =>
				@d3Component.transition()
		return

window.app = new App()
app.run()