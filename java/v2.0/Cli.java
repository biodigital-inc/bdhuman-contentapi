import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

public class Cli {
 private static final Logger log = Logger.getLogger(Cli.class.getName());
 private String[] args = null;
 private Options options = new Options();

 public Cli(String[] args) {

  this.args = args;
  options.addOption("h", "help", false, "show help.");
 }

 public void parse() {

  CommandLineParser parser = new DefaultParser();
  CommandLine cmd = null;

  try {
   cmd = parser.parse(options, args);
	
   if (cmd.hasOption("h")){
		help();
	}
	   
  } catch (ParseException e) {
   log.log(Level.SEVERE, "Failed to parse comand line properties", e);
   help();
  }
 }

 private void help() {
  // This prints out some help
  HelpFormatter formater = new HelpFormatter();
  formater.printHelp("Client", options);
  System.exit(0);
 }
}