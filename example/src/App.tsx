import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
import Video from 'react-native-videokit';
import { useState } from 'react';

const source1 = {
  uri: 'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
};
const source2 = { uri: 'https://www.w3schools.com/html/mov_bbb.mp4' };

export default function App() {
  const [source, setSource] = useState('source1');

  return (
    <View style={styles.container}>
      <Text>Result</Text>
      {source === 'source1' && (
        <Video
          isUserInteractionEnabled={true}
          source={source1}
          autoPlay={false}
          muted={true}
          style={{ flex: 1 }}
        />
      )}
      {source === 'source2' && (
        <Video
          isUserInteractionEnabled={true}
          source={source2}
          autoPlay={true}
          muted={false}
          pictureInPicture={false}
          style={{ flex: 1 }}
        />
      )}
      <View style={{ flex: 1 }}>
        <Button
          title={'Video 1'}
          onPress={() => {
            setSource('source1');
          }}
        />
        <Button
          title={'Video 2'}
          onPress={() => {
            setSource('source2');
          }}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
