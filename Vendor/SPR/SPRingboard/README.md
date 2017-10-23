SPRingboard
===========

_(I see what you did there!)_

SPRingboard is a collection of reusable software components created by SPR to
accelerate mobile application development. It is divided into `Core` components
and `iOS` components. In the future, it may also have `tvOS` and `watchOS`
components. 

`Core` components only rely on Swift's core libraries: Foundation, libdispatch,
and XCTest.

`iOS` components make use of UIKit and other platform frameworks. Additionally,
it provides extensions to standard Swift object types and `Core` components
that provide functionality specifically for iOS apps. 


Using in a Project
------------------

Follow the steps in this section to use SPRingboard in your iOS project. 

### Prerequisites

- The project must have an Xcode workspace (a `.xcworkspace` file). For SPR projects, this is generally created by CocoaPods.

### Instructions

This looks complicated because the instructions break things into small steps, but it's very easy and takes less than 30 seconds when you learn what you're doing. 

1.  Close Xcode.

2.  Add the SPRingboard source code and Xcode project files to your repository. 
    1. In the terminal at the root of your project's repository, run:

            mkdir -p Vendor/SPR
            git clone \
                git@bitbucket.org:sprconsulting/springboard-swift.git \
                --depth=1 \
                Vendor/SPR/SPRingboard
            rm -Rf Vendor/SPR/SPRingboard/.git*

3.  Add the SPRingboard project to your app's Xcode workspace:
    1. Open your application's Xcode workspace.
    2.  In the Project Navigator (⌘⇧J), click the + in the bottom left
    3.  Select: Add Files to "Project"… (where "Project" is the name of your 
        project).
    4.  Navigate into the "Vendor" folder, "SPR" folder, then "SPRingboard" 
        folder. 
    5.  Select the "SPRingboard.xcodeproj" file.
    6.  Click the "Add" button.

4.  Add the SPRingboard framework as an embedded binary for your app:
    1.  In the Project Navigator (⌘⇧J), select _your app's_ Xcode project.
    2.  Select the target for your app; i.e., _not_ the Tests target.
    3.  In the "General" tab, find the "Embedded Binaries" section.
    4.  Click the + button
    5.  Select "SPRingboard" > "Products" > `SPRingboard.framework` iOS
    6.  Click the "Add" button

Done! When you want to use SPRingboard components in a file, add an `import` statement for the module, just like you do for Foundation or UIKit:

    import SPRingboard


Updating SPRingboard in a Project
---------------------------------

To be written.


License
-------

The copyright to SPRingboard is owned by SPRI, LLC (i.e., "SPR Consulting").
SPRingboard is open source software, licensed under the terms of the MIT
license. See the `LICENSE` file for more information.

