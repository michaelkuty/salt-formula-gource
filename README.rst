
======
Gource
======

OpenGL-based 3D visualisation tool for source control repositories. This formulas helps to generate video from multiple git reposiotires.

Sample pillars
==============

Single gource service

.. code-block:: yaml

    gource:
    client:
      enabled: true
      workspace: /media/majklk/9ECC42B6CC42890B
      video:
        leonardo:
          resolution: 1920x1080
          convert: true
          source:
            core:
              address: https://github.com/django-leonardo/django-leonardo.git
            package_index:
              address: https://github.com/leonardo-modules/leonardo-package-index.git
            blog:
              address: 'git@repo1.robotice.cz:leonardo-modules/leonardo-module-blog.git'

Read more
=========

* links
