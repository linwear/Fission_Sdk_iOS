#  Change List

This is in reverse chronological order, so newer entries are added to the top.

## v1.7.0

### Fixed

- Normal OTA failure on specific iPhone (iPhone xs);
- Other minor issues;


## v1.6.0

### Added

- Support BootPatch OTA;
- Support reorder files;
    * Add `hasReorderedFiles` in `RTKDFUUpgrade.h`


## v1.5.0

### Brief

Replace with DocC archive;

Known issues fixed;


### Updated

- Use DocC package to provide documentation;
- Image version for Bee3Pro supported;

### Fixed

- Minor bugs fixes;


## v1.4.9

### Updated

- The timeout of copy image cmd;
- The format of image version;

### Fixed

- EAPs issue;
- Reset cmd issue;


## v1.4.8

### Added

- Support different EAPs;

### Fixed

- Get image versions issue;
- Not support buffer check issue;
- User data ota issue;


## v1.4.7

### Updated

- Refactor SDK;
    * Delete `-DFUUpgrade:withDevice:showFeatureInfoAvailable:andConsistency:withStartHandler:` in `RTKDFURoutine.h`
    * Rename `-updateConnectionParameterWithMinInterval:maxInterval:latency:suspervisionTimeout:completionHandler:` to `-updateConnectionParameterWithMinInterval:maxInterval:latency:supervisionTimeout:completionHandler:` in `RTKDFUConnectionUponGATT.h`


## v1.4.6

### Added

- Support test mode;
    * Add `setModeToStressTestWithCompletionHandler` in `RTKDFURoutine.h`


## v1.4.5

### Added

- Support VP ID update;
    * Add `activeVPID` in `RTKDFUUpgrade.h`
    * Add `canUpdateVPID` in `RTKOTADeviceInfo.h`
    * Add `VPID` in `RTKOTAUpgradeBin.h`
- Support checking image feature;
    * Add `- (void)checkFeatureInfoConsistencyOfImages:withCompletionHandler:` in `RTKDFURoutine.h`
    * Add `- (void)DFUUpgrade:withDevice:showFeatureInfoAvailable:andConsistency:withStartHandler:` in `RTKDFUUpgrade.h`
    * Add `checkFeatureInfo` in `RTKDFUUpgrade.h`
    * Add `imageFeature` in `RTKOTAUpgradeBin.h`


## v1.4.4

### Fixed

- Crash issue caused by disconnection during upgrade;
- OTA failed due to incorrect connection status after switching to OTA mode;
- Crash issue due to waiting for characteristics write response out of order;


## v1.4.3

### Added

- Support new IC 14;

### Updated

- Update OTASDKDemo;


## v1.4.2

### Added

- Support strict image check mechanism;
    * Add `usingStrictImageCheckMechanism` in `RTKDFUUpgrade.h`


## v1.4.1

### Added

- Support checking pub key (0x12);
    * Add `-(void)checkImagesKeyOfCount:andKeyInfo:withCompletionHandler:` in `RTKDFURoutineGATT.h`

### Fixed

- The value of invalid image version;
- The wait time for reconnection;
- The issue caused by header files error;
- The battery check condition;


## v1.4.0

### Added

- Support opcode 0x12 (report image number);
    * Add `- (void)reportImageID:currentImageNumber:totalImageNumber:withCompletionHandler:` in `RTKDFURoutineGATT.h`
- Get inactive Bins informations during the prepareForUpgrade process;
    * Add `inactiveBins` in `RTKOTADeviceInfo.h`

### Fixed

- Demo issue: after the first upgrade, the OTAProfile becomes nil and then the device cannot be connected again;
- Some process issues in the new SDK;


## v1.3.10

### Added

- Refactor the SDK;
- Support IAP;


## v1.3.0

### Added

- Support a new protocol type(0x0012);

### Updated

- The name of images;


## v1.2.1

### Added

- The format of CMD 0x04;


## v1.2.0

### Updated

- The format of (DSP Config/DSP APP/DSP SYS/LowerStack/VP) image version;


## v1.1.29

### Added

- Support VP Upgrade(For AT);
    * Add `canUpdateVP` and `isVPMode` in `RTKOTAPeripheral`
- Support a new protocol type(0x0013);
    * Change the type of `protocolType` from `RTKOTAProtocolType` to `uint16_t` in `RTKOTAPeripheral`
- Support 8763E watch OTA;
    * Add `-[RTKMultiDFUPeripheral reorderFiles]`

### Updated

- The type of images;

### Fixed

- Crash issue caused by file parsing error (length = 0 in MPHeader);


## v1.1.28

### Updated

- The ImageId of images;

### Fixed

- The issue where Ext2 is not packaged in the upgrade file;


## v1.1.27

### Updated

- The image header offset;


## v1.1.26

### Added

- Support 8763E OTA;

### Updated

- The SHA256 offset;

### Fixed

- Crash issues caused by repeated definition of errors;


## v1.1.24

### Added

- Print framework version;


## v1.1.22

### Added

- Support for app to delay active image;
