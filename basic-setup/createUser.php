<?php

require_once dirname(__FILE__) . '/../lib/Application.php';
Horde_Registry::appInit('horde', array('authentication' => 'none'));

$auth = $injector->getInstance('Horde_Core_Factory_Auth')->create();

$auth->addUser('administrator', array('password' => 'administrator'));
