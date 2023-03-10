
# ViewFullObjet -Fast navigation around large objects.
# A plugin for Sketchup that allows you to quickly zoom out of a current view.

# This script helps to navigate around an object. If you have to change different areas of a large object, 
# you have to zoom out and zoom in again and again. With this script you can zoom out in one operation and display the whole 
# the whole object on the screen so that you can select another area to zoom in and work on.
# The script activates the Zoom Window tool to easily and quickly zoom in on the next area to work on. 
# A keyboard shortcut helps a lot.

# Select an element and then or place an object in the middle of the screen (with a double click with the Orbit tool), 
# then activate the plugin with the keyboard shortcut. Everything that touches the selected element will be presented on the screen.
# The Zoom Window tool will then be activated to zoom in on another part of the work.

# Thanks to ChatGPT who helped me to realize this script in the Ruby language that I don't know.

# Correct when you select the metre as unit.

# INSTALLATION: 
#   - Save the file view-Full-Object.rbz in the directory of your choice. (the .rbz file is nothing else than the .rb file which has been zipped and whose extension has been changed to .rbz)
#   - Use the extension manager in the Window menu to add the plugin
#   - Associate a keyboard shortcut in Window/Preference

# USE : 
#   When you are zoomed on a part of an object and you want to move to another zoom of the object,
#   simply use the shortcut key to bring up all the elements of the object on the screen.
#   The object being zoomed in will either be the object in the center of the screen or the object with an element selected.
#   For example, it is nice to double-click with the Orbit tool on the object to be cropped.
#   After that, the Zoom Window tool is selected, which allows you to quickly zoom in by selecting the new 
#  working area.
#   If you do not want to zoom in, simply select another tool.

# Translated with www.DeepL.com/Translator (free version)

# -----------------------------------

# ViewFullObjet - Navigation rapide autour des grands objets.
# Un plugin pour Sketchup qui permet de d??zoomer rapidement d'une vue actuelle.

# Ce script aide ?? naviguer autour d'un objet. Si on doit modifier diff??rentes zones d'un grand objet, 
# il faut sans cesse d??zoomer et re-zoomer. Avec ce script, on peut d??zoomer en une op??ration et afficher 
# tout l'objet ?? l'??cran de fa??on ?? pouvoir s??lectionner une autre zone pour y zoomer et y travailler.
# Le script active l'outil Zoom Window pour rezoomer facilement et rapidement sur la prochaine zone ?? travailler. 
# Un raccourci clavier aide beaucoup.

# S??lectionnez un ??l??ment puis ou bien placez un objet au milieu de l'??cran (avec un double clic avec l'outil Orbit), 
# puis activez le plugin avec le raccourci clavier. Tout ce qui touche l'??l??ment s??lectionn?? sera pr??sent?? ?? l'??cran.
# L'outil Zoom Window sera ensuite activ?? pour permettre de zoomer sur une autre partie du travail.

# Merci ?? ChatGPT qui m'a aid?? ?? r??aliser ce script dans le  langage Ruby que je ne connais pas.

# Correct quand on selectionne le metre comme unit??.

# INSTALLATION : 
#   - Sauvez le fichier view-Full-Objet.rbz dans le r??pertoire de votre choix. (le fichier .rbz n'est rien d'autre que le fichier .rb qui a ??t?? zipp?? et dont l'extension a ??t?? modifi??e en .rbz)
#   - Utilisez le manager d'extension dans le menu Fen??tre pour ajouter le plugin
#   - Associez un raccourci clavier dans Window/Preference

# UTILISATION : 
#   Quand on est fort zoom?? sur une partie d'un objet et que l'on d??sire se d??placer vers une autre zoom de l'objet,
#   il suffit d'utiliser la touche de raccourci pour faire appara??tre tous les ??l??ments de l'objet ?? l'??cran.
#   L'objet cadr?? sera, soit l'objet au centre de l'??cran, soit l'objet dont un ??l??ment est s??lectionn??.
#   Par exemple, il est sympa de faire un double clic avec l'outil Orbit sur l'objet qui devra ??tre cadr??.
#   Apr??s cela, l'outil Zoom Window est s??lectionn??, cela permet de rezoomer rapidement en s??lectionnant la nouvelle 
#  zone de travail.
#   Si on ne d??sire pas rezoomer, il suffit de s??lectionner un autre outil.



 
# require 'sketchup.rb' // maybe not necessary
require 'extensions.rb'

# C:/Users/d/AppData/Roaming/SketchUp
# C:/Users/d/AppData/Roaming/SketchUp/SketchUp 2021/SketchUp/Plugins/

# https://ruby.sketchup.com
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

    # str = sprintf("ezX=%.3f  ezy=%.3f  ezz=%.3f ", ezX * camera.direction.x, ezy * camera.direction.y, ezz * camera.direction.z  )
    # #  p str

      # It's necessary to selct the pointer tool.
    Sketchup.send_action("selectSelectionTool:")
  
    model = Sketchup.active_model
    view = model.active_view
    camera = view.camera

    selected = model.selection
    if selected.length == 0  
      width = view.vpwidth
      height = view.vpheight
      ph = view.pick_helper
      ph.do_pick(width / 2, height / 2)
      best_entity = ph.best_picked
      if best_entity
        # model.selection.clear
        model.selection.add(best_entity)
      end
    end

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