.. image:: https://secure.travis-ci.org/datakurre/pyconfi2016.svg?branch=master
   :alt: Travis CI badge
   :target: http://travis-ci.org/datakurre/pyconfi2016

Summary
=======

From the `ZODB mailing list`_ introduction:

    ”ZODB has significant advantages over other persistence technologies.  In
    relational databases it is hard and slow to store a tree.  JSON databases
    do store trees but not graphs.  MongoDB has problems with fine-grained
    transaction management across document boundaries. PostgreSQL has excellent
    transaction management, but does not support arrays of heterogeneous
    objects.  And of course once you are in a pure dynamic Python environment,
    there are all kinds of things that you can do that you could not even
    imagine doing with a traditional database.”

Contents
========

``slides.tex``
    Related PyConFI 2016 presentation slides

``ZODB - the Python database.ipynb``
    Jupyter notebook with the presentation examples

``requirements.txt``
    ``pip install -r requirements.txt`` for the Jupyter notebook with
    required Python dependencies (to be started with ``jupyter notebook``)

``mycms/``
    Example SubstanceD_ application created with ``pcreate -s substanced
    mycms`` and with the built-in publication workflow enabled

``mycms/requirements.txt``
    ``pip install -r requirements.txt`` for the SubstanceD application
    (to be started with ``pserve development.ini``)

.. _SubstanceD: http://substanced.net/


Links
=====

zodb.org_
    Official ZODB documentation, tutorial and links to relate material.

`ZODB mailing list`_
    Official ZODB mailing list for dicussion about ZODB and asking for help.

.. _zodb.org: http://zodb.org/
.. _ZODB mailing list: https://groups.google.com/forum/#!forum/zodb
