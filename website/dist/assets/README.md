# Public Assets Directory

This directory contains static assets that are served directly without processing.

## Directory Structure

```
public/assets/
├── fonts/          # Custom font files (.woff2, .woff, .ttf)
├── icons/          # Custom icon files (.svg, .png)
├── images/         # Application images and graphics
└── README.md       # This file
```

## Images

Current image assets:

| File | Size | Description |
|------|------|-------------|
| `app-icon.png` | 26KB | Application icon with background |
| `app-icon-transparent.png` | 22KB | Application icon with transparent background |
| `brand-logo.png` | 24KB | Brand logo with background |
| `brand-logo-transparent.png` | 21KB | Brand logo with transparent background |
| `storebase-logo.png` | 21KB | StoreBase logo with transparent background |
| `splash.png` | 31KB | Splash screen image |

## Usage in Code

### TypeScript/React

```tsx
import { Images } from '@/core/constants/assets';

// Use in JSX
<img src={Images.brandLogo} alt="Brand Logo" />
<img src={Images.appIcon} alt="App Icon" />

// Preload images
import { AssetUtils } from '@/core/constants/assets';
await AssetUtils.preloadImage(Images.splash);
```

### Direct URL Access

All files in `public/assets/` are accessible via absolute paths:
- `/assets/images/app-icon.png`
- `/assets/images/brand-logo.png`
- etc.

## Best Practices

1. **File Naming**: Use kebab-case (e.g., `brand-logo.png`, not `brand name logo.png`)
2. **Image Optimization**: Compress images before adding them
3. **File Organization**:
   - Images: `images/`
   - Fonts: `fonts/`
   - Icons: `icons/`
4. **Asset References**: Use `@/core/constants/assets` for type-safe imports

## Font Awesome Icons

For Font Awesome icons, use `@/core/constants/app-icons`:

```tsx
import { AppIcons } from '@/core/constants/app-icons';

const iconClass = AppIcons.getClass('dashboard');
```

## Notes

- Files in `public/` are **not processed** by Vite/build tools
- They are copied as-is to the build output
- Use for assets that don't need optimization or processing
- For component-specific assets that need processing, use `src/assets/` instead
