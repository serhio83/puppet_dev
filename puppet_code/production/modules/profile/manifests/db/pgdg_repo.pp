# profile::db::pgdg_repo install pgdg common repo

class profile::db::pgdg_repo {
  yumrepo { 'pgdg-common':
    descr   => 'pgdg-common',
    enabled => 1,
    baseurl => 'https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-7-x86_64/'
  }
}
