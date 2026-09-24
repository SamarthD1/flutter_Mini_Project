#!/bin/bash
set -e

echo "=== Installing Flutter SDK on Vercel ==="
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable flutter
fi

export PATH="$PATH:$(pwd)/flutter/bin"

echo "=== Flutter Doctor ==="
flutter doctor -v

echo "=== Building Flutter Web Release ==="
flutter config --enable-web
flutter build web --release

echo "=== Build Complete ==="
