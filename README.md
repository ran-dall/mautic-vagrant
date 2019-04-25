# 👊 [Mautic](https://www.mautic.org/) on [Vagrant](https://www.vagrantup.com/): MADE MAGICALLY EASY!

**Mautic is a great tool; I hope if you're here, you already knew that.** Either way, this repository is for anyone wanting to harness the power of Mautic, pretty much anywhere; without a hiccup or delay and crave a 'right here, right now' type-solution to their dreams of becoming the next  'over-night millionaire.' Just kidding...(but seriously while this tool won't make you millions over-night, it will help to get you moving the right direction.)

> I (@ran-dall) started this project as started as an effort to help new and existing Mautic users **set up a Mautic instance on different cloud providers and their local machines for testing/demonstration purposes.**  

These set-ups are not intended to follow all of what may be considered **`best-practices` by your specific cloud provider,** but the effort is made to follow **Vagrant `best-practices.`** Sometimes those efforts are hindered by the capabilities of the plugins available for the specific cloud provider.   

Below you'll find the revalant notes and `caveats` for each set-up.

---
**Note:** Currently, this project only supports setting up in a `local-environment` on `Virutal-Box.` However, I intend to add more providers soon.

---
### Local Environment (Virtual-Box)

#### `Caveats`

##### `Vagrantfile`
* I pull the [`debian/contrib-stretch64`](https://app.vagrantup.com/debian/boxes/stretch64) box to [avoid any potential `nfs` problems.](https://github.com/hashicorp/vagrant/issues/6769) You could switch this back to [`debian/stretch64`](https://app.vagrantup.com/debian/boxes/stretch64) if you'd like; but if you do, it would recommend you also install the [`vagrant-vbguest`](https://github.com/dotless-de/vagrant-vbguest) to [make sure there are no hiccups with your instance's installation.](https://github.com/hashicorp/vagrant/issues/6769#issuecomment-229497486) You could also probably switch this to [some other `Debian 9` based box](https://app.vagrantup.com/boxes/search?utf8=%E2%9C%93&sort=downloads&provider=&q=Debian+9), but your mileage may vary.

##### `provisioners/install-mautic-system.sh`

* To create the `MariaDB` database needed by Mautic, you need to supply a database name (`DBNAME `), host (`DBHOST`), user (`DBUSER `), and password (`DBPASSWD `). **[All the required `variables` have already set for you in the provisioning script](https://github.com/ran-dall/mautic-vagrant/blob/b6f7863577af1e7ec323e27eb33393272c80af68/Vagrantfile#L78) as follows,** *feel free to change the values as you see fit (and you know what you're doing).*
	- `DBHOST`=`localhost`
	- `DBNAME`=`mauticdb`
	- `DBUSER`=`mauticuser`
	- `DBPASSWD`=`vagrant`

#### Notes
* Basic `SSL` has been implemented for `localhost` to fullfill the miniumum deployment requirements. Access `https://` to bypass any Mautic installation warnings. 
	
	##### Initalize
	
	Clone repo and run `vagrant up` in project root directory.



