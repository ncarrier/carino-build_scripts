# Build scripts for the packages of the carino project

This holds the build scripts for the software packaged so far, for the carino
project. Since carino isn't aimed at creating a linux distribution, the package
list is kept minimalist and as much options as possible have been disabled
because they weren't useful by the time of packaging.

## Build system

For other details, please see the build.sh section of the README.md file for the
carino-tools project.  
A file in the build_scripts directory is considered a build script if it ends
with **.carbuild**. It is considered a configuration script if it ends with
**-config.carbuild**, the only difference is that no -dirclean target is handled
for a configuration script.

### Features

The build system is kept as simple as possible for various reasons:

1. Build speed is important as it reduces the modify / build / update / test
   cycles
2. A simple build system is simpler to understand and master
3. If the need for a more complete system is proven, then an already exisiting
   solution must be used. Creating a build system can quickly be too much
   complicated and become a hell to maintain.

What does the build system is:

* create the base tree structure for packages' build scripts to execute properly
* populate a set of needed variables like compiler path, flags...
* execute build scripts in order
* handle a -dirclean target, allowing to rebuild from scratch a package
* allow to update the target with the needed bits, when a package is built
* allow to create the final SD card image for booting the system

What the build system _doesn't_ do:

* manage dependencies, you must specify the packages to build, in the right
  order, by yourself.
* no flags passing between modules, each package must know how to link and build
  against it's dependencies.
* inter-packages parallel build, though each packages can use parallel build by
  passing a -j option to make
* avoid redoing extraction or configuration steps
* no advanced features like generating a SDK, various flavors...
* no package configuration, documentation building, code checking, though it can
  be achieved in a per-package basis with dedicated build scripts.

### Directories

Three locations are to be considered when building / packaging something :

* **PACKAGE\_BUILD\_DIR**: Directory where the build script can do what it
  needs for the build. It is guaranteed to exist prior to the execution of the
  script. Note that using this directory isn't mandatory: some packages don't
  need to produce intermediate files, for examples, extremely simple test
  programs like tests_gpio, have only one source file and are built with one
  command-line, directly in the final dir.
* **STAGING\_DIR**: Where the build scripts must install what can be needed by
  others packages' build scripts, mainly .a, .h and .so files for libraries.
  Others files can be interesting, for example pkg-config files, or others.
  Under the **STAGING\_DIR** directory, no other directory is guaranteed to
  exist, so they must be created by the packages' build scripts when they need
  it.
* **FINAL\_DIR**: Where the build script must install what must be present on
  the final root filesystem. This includes executables, .so files (but no .a) or
  any other resource which can be needed at run time.  
  Under the **FINAL\_DIR** directory, no other directory is guaranteed to exist,
  so they must be created by the packages' build scripts when they need it.  
  More details on the final directory's tree structure are given in it's
  [dedicated section](#Tree structure for the final directory).

### Basic structure of build scripts

Build scripts usually follow similar steps, with some being absent (or merged
with others) in certain scripts not needing them:

1. The source code is extracted / copied to the **PACKAGE\_BUILD\_DIR**:  
   This step concerns mainly packages shipped as an archive, like busybox,
   hostapd...  
   Usually, it is considered a good practice not to build in the source tree,
   but when the source is copied, it is considered not mandatory and in
   practice, the existing packages nearly all build in the source tree, but do
   modify only files in the **PACKAGE\_BUILD\_DIR**.
2. The package is configured:  
   Not all packages are concerned. For some, a configure script must be ran
   (e.g. autotools), for others, a configuration file must be copied (linux
   kernel...). For the latter, the configuration file to copy should be stored
   in the _carino-config_ sub-project.  
   In this step, if a DEST\_DIR, or analogous, must be specified, then it should
   point to the staging dir.
3. The package is built:
   Usually with make, but ${TOOLCHAIN_PREFIX}-gcc can be invoked directly.
4. The package is installed **in the staging directory**:
   Usually with make install, sometimes with manual copies.  
   For host tools build, installation must take place in the
   **STAGING\_HOST\_DIR** directory.
5. What is needed at runtime on target, is copied in the final directory:
   Packages' build scripts are responsible of knowing what the have to install.
   No automatic copy is attempted. For helping in that process of choosing what
   must be copied to final, a list of the files installed in staging is
   maintained for each package by the build system, in a
   BUILD\_DIR/target/target.staging\_files file.  
   Note that **NOTHING** must be installed in the final directory by host tools
   build.

## Tree structure for the final directory

Tree structure must be kept as simple as possible:

* **/bin**: contains the executable files, with the exception of system
  services, managed by /etc/inittab which should be put in /sbin. By the time of
  writing, it concerns only adbd, udhcpd and hostapd.
* **/boot**: contains the u-boot configuration, the linux kernel and the device
  tree. It's content should not be altered.
* **/dev**: should stay empty, a devtmpfs will be mounted there at startup.
* **/etc**: contains the configuration files, most of them coming from
  config/skel.
* **/lib**: contains the libraries' shared object files. No /usr/lib, /opt/lib
  or any other location should be used. Name clashes can be resolved, when they
  occur, by creating a subdirectory in /lib.
* **/libexec**: should contain executables needed by libraries to function.
* **/proc**: should stay empty, a protfs will be mounted there at startup.
* **/sbin**: should contain system services' executables, managed by inittab.
* **/sys**: should stay empty, a protfs will be mounted there at startup.
* **/tmp**: should stay empty, a protfs will be mounted there at startup.
* **/var**: used by some packages at runtime.

## License

    This is part of the Carino project documentation.
    Copyright (C) 2015
      Nicolas CARRIER <carrier dot nicolas0 at gmail dot com>
    See the file doc/README.md for copying conditions
