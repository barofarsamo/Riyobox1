allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    afterEvaluate {
        val project = this
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android")
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                val currentNamespace = getNamespace.invoke(android)
                if (currentNamespace == null) {
                    if (project.name == "flutter_cast_video") {
                        setNamespace.invoke(android, "com.vrt.flutter_cast_video")
                    }
                }
            } catch (e: Exception) {
                // Ignore if methods don't exist
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
