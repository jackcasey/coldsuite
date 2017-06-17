# Cold Suite
## Curated cold storage and offline cryptocurrency tools

Note that Cold Suite is a 'package generator' of sorts and doesn't contain any tools of its own. It just references and downloads freely available web based tools when the script is run by a user.

When you run the script it will download the offline web versions of the included tools (from definitions in `./tools.json`) and put them all in a `tools/` directory you can then copy to an air-gapped machine. 

Obviously to trust this tool you should carefully inspect and understand `./coldsuite.rb` and make sure you recognise and verify the tools and urls listed in `tools.json`. I've tried to make the code simple so that it can be easily audited.

I built this for myself as I was having difficulty finding all the best, most trustworthy tools on line and didn't relish keeping a package of them up to date. I decided to release it in the hope that others help me maintain and curate it, or tell me that I'm reinventing the wheel and point me at a better alternative!

I am looking for advice on the right tools to include. Preferably no real double ups in functionality and only the most trusted in the community.

Usage: 
```
> git clone https://github.com/jackcasey/coldsuite.git
> cd coldsuite
> ./coldsuite.rb
> cp -R tools/ <THUMBDRIVE ETC>
```

Requires:  `ruby`, `curl`, `unzip`.

Tested on: MacOS and ruby 2.3.1 but I'm trying to make it portable.
