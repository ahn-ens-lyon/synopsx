Synopsx
=======

SynopsX is a light framework to publish full XML corpus with BaseX XML native database.

Installation
---

SynopsX 2.0 requires BaseX version 8.0

```bash
  git clone https//github.com/ahn-ens-lyon/synopsx.git synopsx
  cd <path-to-basex>/webapp
  ln -s <path-to-synospx>/ synopsx
```

Configuration
---

Copy paste 'config.sample' to 'config.xml'

```bash
  cd <path-to-synopsx>
  cp config.sample config.xml
```

Then open 'config.xml' in an editor and complete with your informations. Copy/paste the exemple to create as many projects as needed. The @default attribute is used to define a default home.

Creates your projects directories in the 'workspace/' directory as specified in the 'config.xml'.  

---

Enjoy !
