Python module `pex100`
======================

**Repository moved to https://github.com/saezlab/pex100**

This module implements a  phosphoassay data analyis workflow.
In its current state, as data is unpublished, it is useless for the public.
Data becomes available upon publication of the paper.

Installation
------------

.. code:: bash
    
    pip install git+https://github.com/saezlab/pex100.git


Requirements
------------

Requires xlrd, openpyxl, numpy, scipy, pandas, pypath and optionally pysemsim
and kinact. For pypath and kinact see https://github.com/saezlab/. For
pysemsim see https://bitbucket.org/deeenes/pysemsim.
Should work under Linux, other Unix and Windows, both in Python 2 and 3.

Quick start
-----------

.. code:: python
        
        import pex100
        b = pex100.Pex100(ncbi_tax_id = 9606)
        b.main()

Authors
-------
Dénes Türei -- turei.denes@gmail.com (feedback, bug reports)

License
-------
GPLv3
