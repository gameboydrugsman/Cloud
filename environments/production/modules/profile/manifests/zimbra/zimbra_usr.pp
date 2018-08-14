# documented
class profile::zimbra::zimbra_usr (
    $domain = jorisdejosselindejong.nl
  ){
  puppet resource zimbra_user domain=$domain
    zimbra_user {
        'joris':
            ensure       => present,
            domain       => $domain,
            aliases      => ['joris@jorisdejosselindejong.nl'],
            user_name    =>  'joris',
            mailbox_size =>  '10G';
     }
}
