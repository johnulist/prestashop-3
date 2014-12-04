<?php
/**
 * bPost Box class
 *
 * @author    Tijs Verkoyen <php-bpost@verkoyen.eu>
 * @author  Serge <serge@stigmi.eu>
 *          Needed to modify this to include optional barcode element
 * @version   3.0.0
 * @copyright Copyright (c), Tijs Verkoyen. All rights reserved.
 * @license   BSD License
 */

class EontechModBpostOrderBox
{
	/**
	 * @var EontechModBpostOrderSender
	 */
	private $sender;

	/**
	 * @var EontechModBpostOrderBoxAtHome
	 */
	private $national_box;

	/**
	 * @var EontechModBpostOrderBoxInternational
	 */
	private $international_box;

	/**
	 * @var string
	 */
	private $remark;

	/**
	 * @var string
	 */
	private $barcode;

	/**
	 * @var string
	 */
	private $status;

	/**
	 * @param EontechModBpostOrderBoxInternational $international_box
	 */
	public function setInternationalBox(EontechModBpostOrderBoxInternational $international_box)
	{
		$this->international_box = $international_box;
	}

	/**
	 * @return EontechModBpostOrderBoxInternational
	 */
	public function getInternationalBox()
	{
		return $this->international_box;
	}

	/**
	 * @param EontechModBpostOrderBoxNational $national_box
	 */
	public function setNationalBox(EontechModBpostOrderBoxNational $national_box)
	{
		$this->national_box = $national_box;
	}

	/**
	 * @return EontechModBpostOrderBoxNational
	 */
	public function getNationalBox()
	{
		return $this->national_box;
	}

	/**
	 * @param string $remark
	 */
	public function setRemark($remark)
	{
		$this->remark = $remark;
	}

	/**
	 * @return string
	 */
	public function getRemark()
	{
		return $this->remark;
	}

	/**
	 * @param string $barcode
	 */
	public function setBarcode($barcode)
	{
		$this->barcode = $barcode;
	}

	/**
	 * @return string
	 */
	public function getBarcode()
	{
		return $this->barcode;
	}

	/**
	 * @param EontechModBpostOrderSender $sender
	 */
	public function setSender(EontechModBpostOrderSender $sender)
	{
		$this->sender = $sender;
	}

	/**
	 * @return EontechModBpostOrderSender
	 */
	public function getSender()
	{
		return $this->sender;
	}

	/**
	 * @param string $status
	 * @throws EontechModException
	 */
	public function setStatus($status)
	{
		$status = \Tools::strtoupper($status);
		if (!in_array($status, self::getPossibleStatusValues()))
			throw new EontechModException(
				sprintf(
					'Invalid value, possible values are: %1$s.',
					implode(', ', self::getPossibleStatusValues())
				)
			);

		$this->status = $status;
	}

	/**
	 * @return string
	 */
	public function getStatus()
	{
		return $this->status;
	}

	/**
	 * @return array
	 */
	public static function getPossibleStatusValues()
	{
		return array(
			'OPEN',
			'PENDING',
			'CANCELLED',
			'COMPLETED',
			'ON-HOLD',
			'PRINTED',
		);
	}

	/**
	 * Return the object as an array for usage in the XML
	 *
	 * @param  \DomDocument $document
	 * @param  string	   $prefix
	 * @return \DomElement
	 */
	public function toXML(\DOMDocument $document, $prefix = null)
	{
		$tag_name = 'box';
		if ($prefix !== null)
			$tag_name = $prefix.':'.$tag_name;

		$box = $document->createElement($tag_name);

		if ($this->getSender() !== null)
			$box->appendChild(
				$this->getSender()->toXML($document, $prefix)
			);
		if ($this->getNationalBox() !== null)
			$box->appendChild(
				$this->getNationalBox()->toXML($document, $prefix)
			);
		if ($this->getInternationalBox() !== null)
			$box->appendChild(
				$this->getInternationalBox()->toXML($document, $prefix)
			);
		if ($this->getRemark() !== null)
		{
			$tag_name = 'remark';
			if ($prefix !== null)
				$tag_name = $prefix.':'.$tag_name;
			$box->appendChild(
				$document->createElement(
					$tag_name,
					$this->getRemark()
				)
			);
		}

		return $box;
	}

	/**
	 * @param  \SimpleXMLElement $xml
	 * @return EontechModBpostOrderBox
	 * @throws EontechModException
	 */
	public static function createFromXML(\SimpleXMLElement $xml)
	{
		$box = new EontechModBpostOrderBox();
		if (isset($xml->sender))
			$box->setSender(
				EontechModBpostOrderSender::createFromXML(
					$xml->sender->children(
						'http://schema.post.be/shm/deepintegration/v3/common'
					)
				)
			);
		if (isset($xml->nationalBox))
		{
			$national_box_data = $xml->nationalBox->children('http://schema.post.be/shm/deepintegration/v3/national');

			// build classname based on the tag name
			$className = 'EontechModBpostOrderBox'.\Tools::ucfirst($national_box_data->getName());
			if ($national_box_data->getName() == 'at24-7')
				$className = 'EontechModBpostOrderBoxAt247';

			if (!method_exists($className, 'createFromXML'))
				throw new EontechModException('Not Implemented');

			$national_box = call_user_func(
				array($className, 'createFromXML'),
				$national_box_data
			);

			$box->setNationalBox($national_box);
		}
		if (isset($xml->internationalBox))
		{
			$international_box_data = $xml->internationalBox->children('http://schema.post.be/shm/deepintegration/v3/international');

			// build classname based on the tag name
			$className = 'EontechModBpostOrderBox'.\Tools::ucfirst($international_box_data->getName());

			if (!method_exists($className, 'createFromXML'))
				throw new EontechModException('Not Implemented');

			$international_box = call_user_func(
				array($className, 'createFromXML'),
				$international_box_data
			);

			$box->setInternationalBox($international_box);
		}
		if (isset($xml->remark) && $xml->remark != '')
			$box->setRemark((string)$xml->remark);
		if (isset($xml->barcode) && $xml->barcode != '')
			$box->setBarcode((string)$xml->barcode);
		if (isset($xml->status) && $xml->status != '')
			$box->setStatus((string)$xml->status);

		return $box;
	}
}
