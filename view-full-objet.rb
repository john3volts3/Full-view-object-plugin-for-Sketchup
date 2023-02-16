
# This script helps to navigate around an object. If you have to change different areas of a large object,
# you have  to zoom out and zoom in again and again. With this script, you can zoom out in one operation and display 
# the whole object on the screen so that you can select another area to zoom in and work on.
# The script activates the Zoom Window tool to easily and quickly re-zoom to the next area to work on.
# A keyboard shortcut helps a lot. 
 
# # Just select an item and activate the plugin (a keyboard shortcut is recommended). Everything that touches the selected element will be presented on the screen.
# The Zoom Window tool will then be activated to zoom in on another part of the work.

# set for metter units

# Thanks to ChatGPT who helped me to realize this script in the Ruby language that I don't know.


# Ce script aide à naviguer autour d'un objet. Si on doit modifier différentes zones d'un grand objet, 
# il faut sans cesse dézoomer et re-zoomer. Avec ce script, on peut dézoomer en une opération et afficher 
# tout l'objet à l'écran de façon à pouvoir sélectionner une autre zone pour y zoomer et y travailler.
# Le script active l'outil Zoom Window pour rezoomer facilement et rapidement sur la prochaine zone à travailler. 
# Un raccourci clavier aide beaucoup.

# Sélectionnez seulement un élément puis activez le plugin (un raccourci clavier est recommandé). Tout ce qui touche l'élément sélectionné sera présenté à l'écran.
# L'outil Zoom Window sera ensuite activé pour permettre de zoomer sur une autre partie du travail.

# Merci à ChatGPT qui m'a aidé à réaliser ce script dans le  langage Ruby que je ne connais pas.

# Correct quand on selectionne le metre comme unité.
 
# require 'sketchup.rb' // maybe not necessary
require 'extensions.rb'

# C:/Users/d/AppData/Roaming/SketchUp
# C:/Users/d/AppData/Roaming/SketchUp/SketchUp 2021/SketchUp/Plugins/

# https://ruby.sketchup.com/top-level-namespace.html
# https://ruby.sketchup.com/Sketchup/Camera.html
#     load 'C:\SketchupPRO-2020\plugin\view-full-objet.rb'
# view = Sketchup.active_model.active_view;camera = view.camera;eye = camera.eye;target= camera.target
# Sketchup.active_model.active_view.camera.fov
#   eye = [1000,1000,1000]; target = [0,0,0]; up = [0,0,1]; my_camera = Sketchup::Camera.new eye, target, up; view = Sketchup.active_model.active_view; view.camera = my_camera

module ViewFullObject

  def self.viewFullObject

    unZoomPower = 500
    # SKETCHUP_CONSOLE.show
    # SKETCHUP_CONSOLE.clear

    str = sprintf("ezX=%.3f  ezy=%.3f  ezz=%.3f ", ezX * camera.direction.x, ezy * camera.direction.y, ezz * camera.direction.z  )
    #  p str

    view = Sketchup.active_model.active_view
    camera = view.camera

    model = Sketchup.active_model
    selected = model.selection
    if selected.length > 0

      sl = 0
      newsl = sl + 1
      while newsl > sl do 

        selection = Sketchup.active_model.selection
        sl = selection.length ##selected.length
        edges = Set.new
        faces = []
        # Add touching faces and adges
        selection.each do |entity|
          if entity.is_a?(Sketchup::Edge)
            edges.merge(entity.faces)
          elsif entity.is_a?(Sketchup::Face)
            faces.concat(entity.edges)
          end
        end

        Sketchup.active_model.selection.add(edges.to_a) 
        Sketchup.active_model.selection.add(faces) 

        newsl = Sketchup.active_model.selection.length ## selected.length

        edges.clear
        edges = nil
      end
    end

    # Sketchup.send_action("selectAllConnected:")

    view = Sketchup.active_model.active_view
    camera = view.camera
    
    # Obtein the selected object
    selected = Sketchup.active_model.selection[0]

   if (Sketchup.active_model.selection.count > 0)
      bounds = selected.bounds
      object_width = bounds.width
      object_height = bounds.height
      
      # Obtein the size of the view
      view_width = view.vpwidth
      view_height = view.vpheight

      # Obtein active selection
      selection = Sketchup.active_model.selection

      # Initialise te totales limits
      min_x, min_y, min_z, max_x, max_y, max_z = nil

      # Browse each object in the selection to find the total limits
      selection.each do |entity|
       bounds = entity.bounds
       if min_x.nil? || bounds.min.x < min_x
         min_x = bounds.min.x
       end
       if min_y.nil? || bounds.min.y < min_y
         min_y = bounds.min.y
       end
       if min_z.nil? || bounds.min.z < min_z
         min_z = bounds.min.z
       end
       if max_x.nil? || bounds.max.x > max_x
         max_x = bounds.max.x
       end
       if max_y.nil? || bounds.max.y > max_y
         max_y = bounds.max.y
       end
       if max_z.nil? || bounds.max.z > max_z
         max_z = bounds.max.z
       end
      end

      # Calculate the total width and height
      width = max_x - min_x
      height = max_y - min_y

      object_width = width
      object_height = height

      center_x = (min_x + max_x) / 2
      center_y = (min_y + max_y) / 2
      center_z = (min_z + max_z) / 2
     
      selection.clear

      zoom = [object_width / view_width, object_height / view_height].max 

      # Set the camera position so that the object is centered
 
      center = [center_x, center_y, center_z]
 
      # Create a displacement vector
      vector = Geom::Vector3d.new(1, 1, 1)

      # Create a target from the center and the vectorr
      target = Geom::Point3d.new(center) + vector

      view.camera.set(center, view.camera.target, view.camera.up, Geom::Vector3d.new(zoom, zoom, zoom))
      view.camera = camera
      view.refresh

      unZoomPower *= zoom * 4   # just arbitrary. Good for meter units.
      view = Sketchup.active_model.active_view
      camera = view.camera
      ex = camera.eye.x - ( unZoomPower * camera.direction.x )
      ey = camera.eye.y - ( unZoomPower * camera.direction.y )
      ez = camera.eye.z - ( unZoomPower * camera.direction.z )
      eye = [ ex, ey, ez ]
      view.camera.set(eye, view.camera.target, view.camera.up)
      view.camera = camera
      view.refresh

      # activate next tools for zooming on the desired zone.
      Sketchup.send_action("selectZoomWindowTool:")
   end

  end

  # # This adds an item to the Camera menu to activate our custom animation.
  # UI.menu("Camera").add_item("Run Float Up Animation") {
  #   Sketchup.active_model.active_view.animation = FloatUpAnimation.new
  # }

  unless file_loaded?(__FILE__)
    menu = UI.menu("Plugins")
    menu.add_item("ViewFullObject") { self.viewFullObject }
    file_loaded(__FILE__)
  end
 
end