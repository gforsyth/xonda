================
xonda Change Log
================

.. current developments

v0.2.4
====================

**Fixed:**

* Added ``importlib`` import so that ``conda activate`` doesn't break 
  everything.  Stupid bug.




v0.2.3
====================

**Changed:**

* ``conda`` imports are now lazy using ``lazyasd`` for a 300ms speedup
  in startup time.  Woo!




v0.2.2
====================

**Added:**

* `conda env create` completions


**Changed:**

* Restored old ``xonda activate`` behavior. Base anaconda is completely removed
  from ``$PATH`` on ``activate`` so there isn't accidental cross-env loading




