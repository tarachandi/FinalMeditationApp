# Import file "MeditationApp_V1_IPHONE6" (sizes and positions are scaled 1:2)
$ = Framer.Importer.load("imported/MeditationApp_V1_IPHONE6@2x")





#############   SETTING TIMER WITH DIAL  ####################


dragOnCircle = require "dragOnCircle"
{AudioPlayer} = require "audio"
audio = new AudioPlayer audio: "audio.mp3"

minutes = new Layer
	x: 333
	y: 955	
	width: 200
	height: 200
	backgroundColor: null
	html: "00"
	style:
		fontWeight: 300
		fontSize: "5rem"
		color: "#8083A2"
	superLayer: $.App
	index:3 #should be 3

countDownBackground = new Layer
	width: 150
	height: 150
	backgroundColor: "rgb(250,250,250)"
	opacity: .5
	x: 302
	y: 893
	superLayer:  $.App
	visible: false
	index: 2
countDownBackground.borderRadius = countDownBackground.width/2




$.Play.onClick (event, layer) ->
	$.timer.visible=true
	$.dash.visible=true
	minutes.visible = true
		


###Make Dash Draggable#####
makeDashDraggable = ->
	dragOnCircle = require "dragOnCircle"
	minutes.html = "00"
	$.dash.x = 352
	$.dash.y = 830
	angle=dragOnCircle.circleDrag $.dash, 111

	$.dash.on "change:x", ->
		minutesCount = Math.floor(Utils.modulate(dragOnCircle.dragAngle, [0, 360], [0, 61],true))
		if  minutesCount < 10
			minutesCount = "0" + minutesCount
	
		minutes.html = minutesCount
		
		if dragOnCircle.dragAngle == 360
			minutes.html = "00"
	
	

makeDashDraggable()


#####INITIAL STATE#####
# $.dot.animate 
# 	properties: 
# 		opacity: .2
# 	time: 1.5
# 	delay: 0
# 	repeat: 3
$.dot.index =0


$.timer.visible=false
minutes.visible =false
$.Play.visible=false
$.dash.visible=false
$.pause.visible=false
$.Stop.visible=false
$.pinkmandala.visible=false
# $.second.visible=false
$.dot.visible=true
$.dot.x=250



#####TRANSITION CLICK ON BUTTON #######

#INITIAL STATE

$.button.on Events.Click, ->
	makeDashDraggable()
	$.button.visible = true
	$.button.scale = 0.8
	$.button.opacity = 1
	$.timer.visible = true
	$.timer.opacity = 0
	$.dash.visible = true
	$.dash.opacity = 0
	minutes.visible=true

	
#FINAL STATE
	$.timer.animate
		properties:
			scale: 1, opacity: 1
		time: 1
	$.dash.animate
		properties:
			scale: 1, opacity: 1
		time: 1
	minutes.animate
		properties:
			scale: 1, opacity: 1
		time: 1
	$.button.visible = false
	$.Play.visible=true

#####TRANSITION CLICK ON PLAY #######

$.Play.on Events.Click, ->
	audio.player.play()
	$.timer.animate
		properties:
			scale: 1, opacity: 0
		time: 1
	$.dash.animate
		properties:
			scale: 1, opacity: 0
		time: 1
	minutes.animate
		properties:
			scale: 1, opacity: 1
		time: 1
		$.pause.visible=true
		$.Stop.visible=true
		$.Play.visible=false
	spinMandala(parseInt(minutes.html))
	countDownBackground.visible = true
	minutes.decrementTimer()
	
		

# RESET HOME SCREEN STATE
resetHomeScreenState = ->
	makeDashDraggable()
	$.bg.x = 0
	$.pinkmandala.x = 182
	$.button.visible= true
	$.MonthChart.x = 808
	$.Year.x = 1170
	$.dot.index = 0
	$.pinkmandala.scale = 1
	$.pinkmandala.visible = false
	$.mandala.opacity = 1
	$.homescreenarrow.visibl = true
	
	return

#FUNCTION TO DECREMENT TIMER
interval = null
minutes.decrementTimer = ->	
	displayTime = ""
	currentTime = parseInt(minutes.html)
	interval = Utils.interval 1, ->
		
		currentTime = currentTime - 1
		if currentTime < 10
			displayTime = "0" + currentTime
		else
			displayTime = "" + currentTime
		minutes.html = displayTime
		if currentTime <= 0
			minutes.html = "00"
			minutes.stopDecrementing()
			return
			
	return

minutes.stopDecrementing = ->
	clearInterval(interval)

#ANIMATE MANDALA
spinMandala =  (spinTime) ->
	animationParams = 
		scale: 1
		rotation: 360
		opacity: 0.89
		options:
			time: spinTime #make this 10 later
			curve: Bezier.linear
			delay: 0.89
			repeat: 0
	
	$.mandala.animate(animationParams)

$.mandala.on Events.AnimationEnd, ->
	this.animate 
		properties:
			opacity: 0
		time: 0.4
	$.pinkmandala.visible=true
	$.button.visible=false
	$.pause.visible=false
	$.Stop.visible=false
	minutes.visible=false
	countDownBackground.visible = false
	return
	
	#####TRANSITION TO SECOND SCREEN #######
$.pinkmandala.on Events.Click, ->
	$.pinkmandala.animate
			x: -750
			rotation: 0
			scale: 0.54
			options:
				time: 2.86
				curve: "ease"
				
	$.bg.animate
			x: -750
			options:
				time: 2.86
				curve: "ease"
				delay:0
	
	
	$.MonthChart.animate
		x: 60
		options:
			time: 3
			curve: "ease"
			index: 4
			
	$.Year.animate
		x: 430
		options:
			time: 3
			curve: "ease"
			index: 5

	$.dot.opacity = .2

	$.dot.animate 
		properties: 
			index: 1
			
		time: 1.5
		delay: 2
		
	$.dot.animate 
		properties: 
			opacity: 1
			
		time: .5
		delay: .5
		repeat: 8
	$.homescreenarrow.visible = false
		


$.Year.onClick ->
	flow = new FlowComponent
	flow.showOverlayRight($.Thirdscreen)
	
$.Month.onClick ->
	flow = new FlowComponent
	flow.showOverlayLeft($.Secondscreen)
$.Year1.onClick ->
	flow = new FlowComponent
	flow.showOverlayRight($.Thirdscreen)
	
	
	#####testing####
$.secondscreenbackbutton.onClick ->
	resetHomeScreenState()
	flow = new FlowComponent
	flow.showOverlayLeft($.App)		
	return
$.thirdscreenbackbutton.onClick ->
	resetHomeScreenState()
	flow = new FlowComponent
	flow.showOverlayLeft($.App)		
	return
$.homescreenarrow.onClick ->
	flow = new FlowComponent
	flow.showOverlayRight($.Secondscreen)
	
		



	

				
			
################################ TRANSITION TO SCREEN TWO ###########################################
# $.Closetracker.visible = false
# secondlayer = new Layer 
# 	width: Screen.width
# 	height: Screen.height
# 	image: $.second.image
# 	y: 0
# 	x: Screen.width
# 	superLayer: $.App
# 	
# $.button.on Events.Click, ->
# 	secondlayer.animate
# 		properties:
# 			y:0 
# 			x:0
# 		curve:"spring(200,70,0)"
# 	$.Closetracker.visible = true
# 		
# 		
# $.Closetracker.x=700
# 
# 
# secondlayer.index = 5
# $.Closetracker.index = 6
# 
# 
# # $.Closetracker.z = 3000
# $.Closetracker.on Events.Click, ->
# 	secondlayer.animate( 
# 		properties:
# 			y: Screen.height
# 		curve: "spring(200,75,0)"
# 	)
# 
# 	$.Closetracker.visible = false
	
	
		
# ################################ TRANSITION TO SCREEN TWO ###########################################
# $.Closetracker.visible = false
# secondlayer = new Layer 
# 	width: Screen.width
# 	height: Screen.height
# 	image: $.second.image
# 	y: Screen.height
# 	superLayer: $.App
# 	
# $.button.on Events.Click, ->
# 	secondlayer.animate
# 		properties:
# 			y:0 
# 		curve:"spring(200,70,0)"
# 	$.Closetracker.visible = true
# 		
# 		
# $.Closetracker.x=700
# 
# 
# secondlayer.index = 5
# $.Closetracker.index = 6
# 
# 
# # $.Closetracker.z = 3000
# $.Closetracker.on Events.Click, ->
# 	secondlayer.animate( 
# 		properties:
# 			y: Screen.height
# 		curve: "spring(200,75,0)"
# 	)
# 
# 	$.Closetracker.visible = false
		



	
	





# 	$.timer.animate
# 			properties:
# 				scale:1
# 				opacity:1
# 				time: 5
# 			
# 			$.timer.visible=true

	







# ################################# ANIMATE THE INDICATOR ###########################################
# $.second.x = 0
# $.dot.x=260

# $.dot.animate 
# 	properties: 
# 		opacity: .2
# 	time: 1.5
# 	delay: 0
# 	repeat: 5











    







# Utils.interval 1, -> 
# 	$.mandala.rotation + 30
# 
# $.mandala.on Events.Click, ->
#     $.mandala.animate
#         properties:
#             rotation: $.mandala.rotation + 10
#         curve: "spring(400,25,0)"
#         
#         layerA = new Layer
# layerA.rotation = 45


    


############# CODE EXAMPLES    #################
# HOW TO ROTATE ON CLICK
# $.mandala.on Events.Click, ->
#     $.mandala.animate
#         properties:
#             rotation: $.mandala.rotation + 10
#         curve: "spring(400,25,0)"

#to hide something
# $.Click.visible=false


#scaling
# layer.scale = Utils.modulate layer.y, [0, 500], [1, 2], true

#CREATING A LAYER	
# 	click = new Layer 
# 	x: 8, y: 40
# 	width: 140, height: 80
# 	backgroundColor: null


		
