// @ts-ignore
import type { ViewProps } from 'react-native';
import type { HostComponent } from 'react-native';
// @ts-ignore
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

export interface NativeProps extends ViewProps {
  source: Readonly<{ uri: string }>;
  autoPlay?: boolean;
  muted?: boolean;
  loop?: boolean;
  isUserInteractionEnabled?: boolean;
}

export default codegenNativeComponent<NativeProps>(
  'VideoView'
) as HostComponent<NativeProps>;
