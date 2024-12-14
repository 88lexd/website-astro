import Zoom from 'react-medium-image-zoom';
import 'react-medium-image-zoom/dist/styles.css';

const ImageZoom = ({ src, alt }) => (
  <Zoom>
    <img src={src} alt={alt} />
  </Zoom>
);

export default ImageZoom;
