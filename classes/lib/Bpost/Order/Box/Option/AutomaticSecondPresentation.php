<?php
/**
 * bPost AutomaticSecondPresentation class
 *
 * @author    Tijs Verkoyen <php-bpost@verkoyen.eu>
 * @version   3.0.0
 * @copyright Copyright (c), Tijs Verkoyen. All rights reserved.
 * @license   BSD License
 */

class TijsVerkoyenBpostBpostOrderBoxOptionAutomaticSecondPresentation extends TijsVerkoyenBpostBpostOrderBoxOption
{
	/**
	 * Return the object as an array for usage in the XML
	 *
	 * @param  \DomDocument $document
	 * @param  string	   $prefix
	 * @return \DomElement
	 */
	public function toXML(\DOMDocument $document, $prefix = null)
	{
		$tag_name = 'automaticSecondPresentation';
		if ($prefix !== null)
			$tag_name = $prefix.':'.$tag_name;

		return $document->createElement($tag_name);
	}
}
