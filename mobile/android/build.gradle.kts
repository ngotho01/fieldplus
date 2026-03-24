plugins {
    // Android Gradle Plugin — teaches Gradle how to build Android apps
    id("com.android.application") version "8.11.1" apply false
    id("com.google.gms.google-services") version "4.3.15" apply false

    // Kotlin plugin — needed since Flutter uses Kotlin for Android
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
