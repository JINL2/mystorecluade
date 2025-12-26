allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Fix for packages missing namespace and low compileSdk in AGP 8+
subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.findByName("android")
            if (android is com.android.build.gradle.BaseExtension) {
                // Fix missing namespace
                if (android.namespace == null) {
                    android.namespace = project.group.toString()
                }
                // Force compileSdk to 35 for all subprojects to fix lStar issue
                android.compileSdkVersion(35)
            }
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
