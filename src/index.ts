/* eslint-disable */

// @ts-ignore
import React, { Component, JSXElementConstructor, ReactElement, ReactNode } from 'react';
import type { NativeProps } from './VideoKitViewNativeComponent';
// @ts-ignore
import { HostComponent } from 'react-native';

// @ts-expect-error nativeFabricUIManager is not yet included in the RN types
const ENABLE_FABRIC = !!global?.__turboModuleProxy;

// @ts-ignore
console.log('IS FABRIC ENABLED', ENABLE_FABRIC, global.__turboModuleProxy);

const Video = require('./VideoKitViewNativeComponent').default

export default Video as HostComponent<NativeProps>
