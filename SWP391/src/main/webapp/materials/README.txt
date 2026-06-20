# Learning Materials Storage
# Place your ZIP/PDF/PPTX files here, organized in subfolders.
# The folder structure must match the FilePath values stored in the Learning_Material table.
#
# Example (matching the sample data):
#
#   materials/
#   └── lab211/
#       ├── lab01.zip       → "Lab01 - Java Basics Review"
#       ├── lab02.zip       → "Lab02 - OOP Fundamentals"
#       ├── lab03.zip       → "Lab03 - Inheritance & Polymorphism"
#       ├── lab04.zip       → "Lab04 - Exception Handling"
#       ├── lab05.zip       → "Lab05 - Collections Framework"
#       ├── midterm.zip     → "Midterm Practice Set"
#       └── final.zip       → "Final Exam Practice"
#
# ─────────────────────────────────────────────────────────────
# HOW TO CONFIGURE A CUSTOM STORAGE DIRECTORY (OPTIONAL)
# ─────────────────────────────────────────────────────────────
# By default, files are served from:
#   {Tomcat webapps}/SWP391/materials/
#
# To store files OUTSIDE the webapp (recommended for production),
# set the context-param "upload.dir" in web.xml:
#
#   <context-param>
#       <param-name>upload.dir</param-name>
#       <param-value>D:/uploads/materials</param-value>
#   </context-param>
#
# Then copy your files to D:/uploads/materials/lab211/lab01.zip etc.
