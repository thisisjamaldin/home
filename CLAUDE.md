# Project notes for AI assistants

Personal portfolio site built with Flutter Web. Source lives in `lib/main.dart`
(single file: profile data, translations, and UI).

## Deployment — IMPORTANT

The site is hosted on GitHub Pages at a **subpath**: https://thisisjamaldin.github.io/home/

Because of the `/home/` subpath, the web build MUST set the base href, otherwise
`manifest.json`, `flutter_bootstrap.js`, etc. resolve against the domain root and
return 404.

Always build with:

```bash
flutter build web --release --base-href /home/
```

A plain `flutter build web` resets `<base href>` to `/` and breaks the live site.
Do NOT hand-edit `index.html` after building — pass `--base-href /home/` instead.

## Branches

- `flutter_code` — source code (edit here).
- `flutter` — deploy branch: the **built web output** at repo root, served by GitHub
  Pages. Update it by building with the base href above and copying `build/web/*`
  to the branch root. Do not put source files on this branch.
