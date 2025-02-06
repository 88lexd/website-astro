import Zoom from 'react-medium-image-zoom';
import 'react-medium-image-zoom/dist/styles.css';

const ImageZoom = ({ src, alt }) => (
  <div style={{
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center'
  }}>
    <Zoom>
      <img src={src} alt={alt} />
    </Zoom>
  </div>
);

export default ImageZoom;
