namespace :update_deq_email_addresses do

  desc "update DEQ email addresses from @deq.state.or.us to @deq.oregon.gov"
  task update_email_addresses: :environment do
    puts 'starting update_email_addresses'

    user_emails = {}

    user_emails['liverman.alex@deq.state.or.us'] = 'alex.liverman@deq.oregon.gov'
    user_emails['mirzakhalili.ali@deq.state.or.us'] = 'ali.mirzakhalili@deq.oregon.gov'
    user_emails['matzke.andrea@deq.state.or.us'] = 'andrea.matzke@deq.oregon.gov'
    user_emails['ullrich.andy@deq.state.or.us'] = 'andy.ullrich@deq.oregon.gov'
    user_emails['parker.angela@deq.state.or.us'] = 'angela.parker@deq.oregon.gov'
    user_emails['borok.aron@deq.state.or.us'] = 'aron.borok@deq.oregon.gov'
    user_emails['anthony.becky@deq.state.or.us'] = 'becky.anthony@deq.oregon.gov'
    user_emails['beth.moore@deq.state.or.us'] = 'beth.moore@deq.oregon.gov'
    user_emails['creutzburg.brian@deq.state.or.us'] = 'brian.creutzburg@deq.oregon.gov'
    user_emails['svetkovich.christine@deq.state.or.us'] = 'christine.svetkovich@deq.oregon.gov'
    user_emails['funk.clara@deq.state.or.us'] = 'clara.funk@deq.oregon.gov'
    user_emails['dou.connie@deq.state.or.us'] = 'connie.dou@deq.oregon.gov'
    user_emails['brown.daniel@deq.state.or.us'] = 'daniel.t.brown@deq.oregon.gov'
    user_emails['sobota.daniel@deq.state.or.us'] = 'daniel.sobota@deq.oregon.gov'
    user_emails['graiver.david@deq.state.or.us'] = 'david.graiver@deq.oregon.gov'
    user_emails['sturdevant.debra@deq.state.or.us'] = 'debra.sturdevant@deq.oregon.gov'
    user_emails['welch.doug@deq.state.or.us'] = 'doug.welch@deq.oregon.gov'
    user_emails['hnidey.emil@deq.state.or.us'] = 'emil.hnidey@deq.oregon.gov'
    user_emails['nigg.eric@deq.state.or.us'] = 'eric.nigg@deq.oregon.gov'
    user_emails['costello.erin@deq.state.or.us'] = 'erin.costello@deq.oregon.gov'
    user_emails['etsegenet.belete@deq.state.or.us'] = 'etsegenet.belete@deq.oregon.gov'
    user_emails['foster.eugene@deq.state.or.us'] = 'eugene.p.foster@deq.oregon.gov'
    user_emails['mcclamma.gayla@deq.state.or.us'] = 'gayla.mcclamma@deq.oregon.gov'
    user_emails['rabinowitz.geoff@deq.state.or.us'] = 'geoff.rabinowitz@deq.oregon.gov'
    user_emails['harry.esteve@deq.state.or.us'] = 'harry.esteve@deq.oregon.gov'
    user_emails['lawson.inez@deq.state.or.us'] = 'inez.lawson@deq.oregon.gov'
    user_emails['palermo.jaclyn@deq.state.or.us'] = 'jaclyn.palermo@deq.oregon.gov'
    user_emails['bloom.james@deq.state.or.us'] = 'james.bloom@deq.oregon.gov'
    user_emails['mcconaghie.james@deq.state.or.us'] = 'james.mcconaghie@deq.oregon.gov'
    user_emails['navarro.jeffrey@deq.state.or.us'] = 'jeffrey.navarro@deq.oregon.gov'
    user_emails['flynt.jennifer@deq.state.or.us'] = 'jennifer.flynt@deq.oregon.gov'
    user_emails['maglinte-timbrook.jennifer@deq.state.or.us'] = 'jennifer.maglinte-timbrook@deq.oregon.gov'
    user_emails['wigal.jennifer@deq.state.or.us'] = 'jennifer.wigal@deq.oregon.gov'
    user_emails['inahara.jill@deq.state.or.us'] = 'jill.inahara@deq.oregon.gov'
    user_emails['sandau.jim@deq.state.or.us'] = 'jim.sandau@deq.oregon.gov'
    user_emails['westersund.joe@deq.state.or.us'] = 'joe.westersund@deq.oregon.gov'
    user_emails['gasik.jon@deq.state.or.us'] = 'jon.gasik@deq.oregon.gov'
    user_emails['jr.giska@deq.state.or.us'] = 'jr.giska@deq.oregon.gov'
    user_emails['ulibarri.julie@deq.state.or.us'] = 'julie.ulibarri@deq.oregon.gov'
    user_emails['major.kaley@deq.state.or.us'] = 'kaley.major@deq.oregon.gov'
    user_emails['williams.karen@deq.state.or.us'] = 'karen.williams@deq.oregon.gov'
    user_emails['kate.strohecker@deq.state.or.us'] = 'kate.strohecker@deq.oregon.gov'
    user_emails['johnson.keith@deq.state.or.us'] = 'keith.johnson@deq.oregon.gov'
    user_emails['billings.kenzie@deq.state.or.us'] = 'kenzie.billings@deq.oregon.gov'
    user_emails['brannan.kevin@deq.state.or.us'] = 'kevin.brannan@deq.oregon.gov'
    user_emails['ratliff.krista@deq.state.or.us'] = 'krista.ratliff@deq.oregon.gov'
    user_emails['merrick.lesley@deq.state.or.us'] = 'lesley.merrick@deq.oregon.gov'
    user_emails['cox.lisa@deq.state.or.us'] = 'lisa.cox@deq.oregon.gov'
    user_emails['bailey.mark@deq.state.or.us'] = 'mark.bailey@deq.oregon.gov'
    user_emails['davis.matthew@deq.state.or.us'] = 'matthew.davis@deq.oregon.gov'
    user_emails['matthew.espie@deq.state.or.us'] = 'matthew.espie@deq.oregon.gov'
    user_emails['rao.meenakshi@deq.state.or.us'] = 'meenakshi.rao@deq.oregon.gov'
    user_emails['martin.michele@deq.state.or.us'] = 'michele.martin@deq.oregon.gov'
    user_emails['hiatt.mike@deq.state.or.us'] = 'mike.hiatt@deq.oregon.gov'
    user_emails['poulsen.mike@deq.state.or.us'] = 'mike.poulsen@deq.oregon.gov'
    user_emails['singh.nicole@deq.state.or.us'] = 'nicole.singh@deq.oregon.gov'
    user_emails['noosheen.pouya@deq.state.or.us'] = 'noosheen.pouya@deq.oregon.gov'
    user_emails['allen.philip@deq.state.or.us'] = 'philip.allen@deq.oregon.gov'
    user_emails['woolverton.priscilla@deq.state.or.us'] = 'priscilla.woolverton@deq.oregon.gov'
    user_emails['rachel.fernandez@deq.state.or.us'] = 'rachel.fernandez@deq.oregon.gov'
    user_emails['nomura.ranei@deq.state.or.us'] = 'ranei.nomura@deq.oregon.gov'
    user_emails['robert.burkhart@deq.state.or.us'] = 'robert.burkhart@deq.oregon.gov'
    user_emails['michie.ryan@deq.state.or.us'] = 'ryan.michie@deq.oregon.gov'
    user_emails['hubler.shannon@deq.state.or.us'] = 'shannon.hubler@deq.oregon.gov'
    user_emails['mrazik.steve@deq.state.or.us'] = 'steve.mrazik@deq.oregon.gov'
    user_emails['schnurbusch.stephen@deq.state.or.us'] = 'stephen.schnurbusch@deq.oregon.gov'
    user_emails['langston.sue@deq.state.or.us'] = 'sue.langston@deq.oregon.gov'
    user_emails['macmillan.susan@deq.state.or.us'] = 'susan.macmillan@deq.oregon.gov'
    user_emails['yelton-bram.tiffany@deq.state.or.us'] = 'tiffany.yelton-bram@deq.oregon.gov'
    user_emails['wollerman.tim@deq.state.or.us'] = 'tim.wollerman@deq.oregon.gov'
    user_emails['roick.tom@deq.state.or.us'] = 'tom.roick@deq.oregon.gov'
    user_emails['pritchard.travis@deq.state.or.us'] = 'travis.pritchard@deq.oregon.gov'
    user_emails['brown.trina@deq.state.or.us'] = 'trina.brown@deq.oregon.gov'
    user_emails['peerman.wade@deq.state.or.us'] = 'wade.peerman@deq.oregon.gov'
    user_emails['loboy.zach@deq.state.or.us'] = 'zach.loboy@deq.oregon.gov'

    update_count = 0
    error_count = 0
    User.all.each do |u|
      if user_emails.key?(u.email)
        new_email = user_emails[u.email]
        u.email = new_email
        if u.save
          update_count += 1
        else
          error_count += 1
        end
      end
    end

    puts "Expected to make #{user_emails.length} updates."
    puts "#{update_count} email addresses were updated. There were #{error_count} errors."

  end

end