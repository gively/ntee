# ntee: a Ruby API for NTEE non-profit categorization

The ntee gem gives you a nice Ruby API for dealing with [NTEE categories](http://en.wikipedia.org/wiki/National_Taxonomy_of_Exempt_Entities) as objects.  You can look up categories and their descriptions by NTEE code and navigate the taxonomy as a tree.

## Example

```ruby
category = NTEE.category("R61")

category.code      # "R61"
category.name      # "Reproductive Rights"
category.parent    # NTEE.category("R60") - "Civil Liberties"
category.ancestors # [NTEE.category("R60"), NTEE.category("R")]
```

Easy-peasy!

## Licensing

This gem is Copyright &copy; 2011-2012 Gively, Inc. and is released under the MIT license.  For more details, please see the LICENSE file.