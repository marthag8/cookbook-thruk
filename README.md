thruk Cookbook
==============
Setup Thruk (http://www.thruk.org/).

Requirements
------------

#### cookbooks
- `apache2`

Attributes
----------

Usage
-----
#### thruk::default
Just include `thruk` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[thruk]"
  ],
  "override_attributes": {
    "thruk": {
      "use_ssl": true,
      "htpasswd": "/etc/shinken/htpasswd.users",
      "cert_name": "_.example.com",
      "cert_ca_name": "gd_bundle",
    }

}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Martha Greenberg
