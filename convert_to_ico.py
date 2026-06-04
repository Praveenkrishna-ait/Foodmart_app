from PIL import Image
import sys

src = 'assets/app_icon.png'
dst = 'windows/runner/resources/app_icon.ico'

try:
    img = Image.open(src).convert('RGBA')
    sizes = [(256,256),(128,128),(64,64),(48,48),(32,32),(16,16)]
    img.save(dst, format='ICO', sizes=sizes)
    print('Wrote', dst)
except Exception as e:
    print('Error:', e)
    sys.exit(1)
