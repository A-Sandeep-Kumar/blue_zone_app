 // Top-level build file where you can add configuration options common to all sub-projects/modules.
 plugins {
    // Use latest Kotlin plugin
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    id("com.android.application") apply false
    id("com.google.gms.google-services") version "4.3.15" apply false
 }
 allprojects {
    repositories {
        google()
        mavenCentral()
    }
 }
 tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
 }