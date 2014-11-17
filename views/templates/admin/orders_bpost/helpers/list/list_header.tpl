{*
* 2014 Stigmi
*
* @author Stigmi.eu <www.stigmi.eu>
* @copyright 2014 Stigmi
* @license http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
*}

{if $version >= 1.5 && $version < 1.6}
	{if !$simple_header}

		<script type="text/javascript">
			$(document).ready(function() {
				$('table.{$list_id|escape} .filter').keypress(function(event){
					formSubmit(event, 'submitFilterButton{$list_id|escape}')
				})
			});
		</script>
		{* Display column names and arrows for ordering (ASC, DESC) *}
		{if $is_order_position}
			<script type="text/javascript" src="../js/jquery/plugins/jquery.tablednd.js"></script>
			<script type="text/javascript">
				var token = '{$token|strval}';
				var come_from = '{$list_id|escape}';
				var alternate = {if $order_way == 'DESC'}'1'{else}'0'{/if};
			</script>
			<script type="text/javascript" src="../js/admin-dnd.js"></script>
		{/if}

		<script type="text/javascript">
			$(function() {
				if ($("table.{$list_id|escape} .datepicker").length > 0)
					$("table.{$list_id|escape} .datepicker").datepicker({
						prevText: '',
						nextText: '',
						dateFormat: 'yy-mm-dd'
					});
			});
		</script>


	{/if}{* End if simple_header *}

	{if $show_toolbar}
		{include file="toolbar.tpl" toolbar_btn=$toolbar_btn toolbar_scroll=$toolbar_scroll title=$title}
	{/if}

	{if !$simple_header}
		<div class="leadin">{block name="leadin"}{/block}</div>
	{/if}

	{block name="override_header"}{/block}


	{hook h='displayAdminListBefore'}
	{if isset($name_controller)}
		{capture name=hookName assign=hookName}display{$name_controller|ucfirst}ListBefore{/capture}
		{hook h=$hookName}
	{elseif isset($smarty.get.controller)}
		{capture name=hookName assign=hookName}display{$smarty.get.controller|ucfirst|htmlentities}ListBefore{/capture}
		{hook h=$hookName}
	{/if}


	{if !$simple_header}
	<form method="post" action="{$action|strval}" class="form" autocomplete="off">

		{block name="override_form_extra"}{/block}

		<input type="hidden" id="submitFilter{$list_id|escape}" name="submitFilter{$list_id|escape}" value="0"/>
	{/if}
		<table class="table_grid" name="list_table">
			{if !$simple_header}
				<tr>
					<td style="vertical-align: bottom;">
						<span style="float: left;">
							{if $page > 1}
								<input type="image" src="../img/admin/list-prev2.gif" onclick="getE('submitFilter{$list_id|escape}').value=1"/>&nbsp;
								<input type="image" src="../img/admin/list-prev.gif" onclick="getE('submitFilter{$list_id|escape}').value={$page|intval - 1}"/>
							{/if}
							{l s='Page' mod='bpostshm'} <b>{$page|intval}</b> / {$total_pages|intval}
							{if $page < $total_pages}
								<input type="image" src="../img/admin/list-next.gif" onclick="getE('submitFilter{$list_id|escape}').value={$page|intval + 1}"/>&nbsp;
								<input type="image" src="../img/admin/list-next2.gif" onclick="getE('submitFilter{$list_id|escape}').value={$total_pages|intval}"/>
							{/if}
							| {l s='Display' mod='bpostshm'}
							<select name="{$list_id|escape}_pagination" onchange="submit()">
								{* Choose number of results per page *}
								{foreach $pagination AS $value}
									<option value="{$value|intval}"{if $selected_pagination == $value && $selected_pagination != NULL} selected="selected"{elseif $selected_pagination == NULL && $value == $pagination[1]} selected="selected2"{/if}>{$value|intval}</option>
								{/foreach}
							</select>
							/ {$list_total|intval} {l s='result(s)' mod='bpostshm'}
						</span>
						<span style="float: right;">
							<input type="submit" id="submitFilterButton{$list_id|escape}" name="submitFilter" value="{l s='Filter' mod='bpostshm'}" class="button" />
							<input type="submit" name="submitReset{$list_id|escape}" value="{l s='Reset' mod='bpostshm'}" class="button" />
						</span>
						<span class="clear"></span>
					</td>
				</tr>
			{/if}
			<tr>
				<td id="adminbpostorders"{if $simple_header} style="border:none;"{/if}>
					<table
					{if $table_id} id={$table_id|escape}{/if}
					class="table {if $table_dnd}tableDnD{/if} {$list_id|escape}"
					cellpadding="0" cellspacing="0"
					style="width: 100%; margin-bottom:10px;">
						<col width="10px" />
						{foreach $fields_display AS $key => $params}
							<col {if isset($params.width) && $params.width != 'auto'}width="{$params.width|intval}px"{/if}/>
						{/foreach}
						{if $shop_link_type}
							<col width="80px" />
						{/if}
						{if $has_actions}
							<col width="52px" />
						{/if}
						<thead>
							<tr class="nodrag nodrop" style="height: 40px">
								<th class="center">
									{if $has_bulk_actions}
										<input type="checkbox" name="checkme" class="noborder" onclick="checkDelBoxes(this.form, '{$list_id|escape}Box[]', this.checked)" />
									{/if}
								</th>
								{foreach $fields_display AS $key => $params}
									<th {if isset($params.align)} class="{$params.align|escape}"{/if}>
										{if isset($params.hint)}<span class="hint" name="help_box">{$params.hint|escape}<span class="hint-pointer">&nbsp;</span></span>{/if}
										<span class="title_box">
											{$params.title|escape}
										</span>
										{if (!isset($params.orderby) || $params.orderby) && !$simple_header}
											<br />
											<a href="{$currentIndex}&{$list_id|escape}Orderby={$key|urlencode}&{$list_id|escape}Orderway=desc&token={$token}{if isset($smarty.get.$identifier)}&{$identifier}={$smarty.get.$identifier|intval}{/if}">
											<img border="0" src="../img/admin/down{if isset($order_by) && ($key == $order_by) && ($order_way == 'DESC')}_d{/if}.gif" /></a>
											<a href="{$currentIndex}&{$list_id|escape}Orderby={$key|urlencode}&{$list_id|escape}Orderway=asc&token={$token}{if isset($smarty.get.$identifier)}&{$identifier}={$smarty.get.$identifier|intval}{/if}">
											<img border="0" src="../img/admin/up{if isset($order_by) && ($key == $order_by) && ($order_way == 'ASC')}_d{/if}.gif" /></a>
										{elseif !$simple_header}
											<br />&nbsp;
										{/if}
									</th>
								{/foreach}
								{if $shop_link_type}
									<th>
										{if $shop_link_type == 'shop'}
											{l s='Shop' mod='bpostshm'}
										{else}
											{l s='Group shop' mod='bpostshm'}
										{/if}
										<br />&nbsp;
									</th>
								{/if}
								{if $has_actions}
									<th class="center">{l s='Actions' mod='bpostshm'}{if !$simple_header}<br />&nbsp;{/if}</th>
								{/if}
							</tr>
							{if !$simple_header}
							<tr class="nodrag nodrop filter {if $row_hover}row_hover{/if}" style="height: 35px;">
								<td class="center">
									{if $has_bulk_actions}
										--
									{/if}
								</td>

								{* Filters (input, select, date or bool) *}
								{foreach $fields_display AS $key => $params}
									<td {if isset($params.align)} class="{$params.align}" {/if}>
										{if isset($params.search) && !$params.search}
											--
										{else}
											{if $params.type == 'bool'}
												<select onchange="$('#submitFilterButton{$list_id|escape}').focus();$('#submitFilterButton{$list_id|escape}').click();" name="{$list_id|escape}Filter_{$key}">
													<option value="">-</option>
													<option value="1"{if $params.value == 1} selected="selected"{/if}>{l s='Yes' mod='bpostshm'}</option>
													<option value="0"{if $params.value == 0 && $params.value != ''} selected="selected"{/if}>{l s='No' mod='bpostshm'}</option>
												</select>
											{elseif $params.type == 'date' || $params.type == 'datetime'}
												{l s='From' mod='bpostshm'} <input type="text" class="filter datepicker" id="{$params.id_date|escape}_0" name="{$params.name_date|escape}[0]" value="{if isset($params.value.0)}{$params.value.0|escape}{/if}"{if isset($params.width)} style="width:70px"{/if}/><br />
												{l s='To' mod='bpostshm'} <input type="text" class="filter datepicker" id="{$params.id_date|escape}_1" name="{$params.name_date|escape}[1]" value="{if isset($params.value.1)}{$params.value.1|escape}{/if}"{if isset($params.width)} style="width:70px"{/if}/>
											{elseif $params.type == 'select'}
												{if isset($params.filter_key)}
													<select onchange="$('#submitFilterButton{$list_id|escape}').focus();$('#submitFilterButton{$list_id|escape}').click();" name="{$list_id|escape}Filter_{$params.filter_key|escape}" {if isset($params.width)} style="width:{$params.width|intval}px"{/if}>
														<option value=""{if $params.value == ''} selected="selected"{/if}>-</option>
														{if isset($params.list) && is_array($params.list)}
															{foreach $params.list AS $option_value => $option_display}
																<option value="{$option_value|escape}" {if $params.value != '' && ($option_display == $params.value ||  $option_value == $params.value)} selected="selected"{/if}>{$option_display|escape}</option>
															{/foreach}
														{/if}
													</select>
												{/if}
											{else}
												<input type="text" class="filter" name="{$list_id|escape}Filter_{if isset($params.filter_key)}{$params.filter_key}{else}{$key}{/if}" value="{$params.value|escape:'htmlall':'UTF-8'}" {if isset($params.width) && $params.width != 'auto'} style="width:{$params.width}px"{else}style="width:95%"{/if} />
											{/if}
										{/if}
									</td>
								{/foreach}

								{if $shop_link_type}
									<td>--</td>
								{/if}
								{if $has_actions}
									<td class="center">--</td>
								{/if}
								</tr>
							{/if}
							</thead>
{elseif $version >= 1.6}
	{if $ajax}
		<script type="text/javascript">
			$(function () {
				$(".ajax_table_link").click(function () {
					var link = $(this);
					$.post($(this).attr('href'), function (data) {
						if (data.success == 1) {
							showSuccessMessage(data.text);
							if (link.hasClass('action-disabled')){
								link.removeClass('action-disabled').addClass('action-enabled');
							} else {
								link.removeClass('action-enabled').addClass('action-disabled');
							}
							link.children().each(function () {
								if ($(this).hasClass('hidden')) {
									$(this).removeClass('hidden');
								} else {
									$(this).addClass('hidden');
								}
							});
						} else {
							showErrorMessage(data.text);
						}
					}, 'json');
					return false;
				});
			});
		</script>
	{/if}
	{if !$simple_header}
		{* Display column names and arrows for ordering (ASC, DESC) *}
		{if $is_order_position}
			<script type="text/javascript" src="../js/jquery/plugins/jquery.tablednd.js"></script>
			<script type="text/javascript">
				var come_from = '{$list_id|addslashes}';
				var alternate = {if $order_way == 'DESC'}'1'{else}'0'{/if};
			</script>
			<script type="text/javascript" src="../js/admin-dnd.js"></script>
		{/if}
		<script type="text/javascript">
			$(function() {
				$('table.{$list_id|escape} .filter').keypress(function(e){
					var key = (e.keyCode ? e.keyCode : e.which);
					if (key == 13)
					{
						e.preventDefault();
						formSubmit(e, 'submitFilterButton{$list_id|escape}');
					}
				})
				$('#submitFilterButton{$list_id|escape}').click(function() {
					$('#submitFilter{$list_id|escape}').val(1);
				});
				if ($("table.{$list_id|escape} .datepicker").length > 0) {
					$("table.{$list_id|escape} .datepicker").datepicker({
						prevText: '',
						nextText: '',
						altFormat: 'yy-mm-dd'
					});
				}
			});
		</script>
	{/if}

	{if !$simple_header}
		<div class="leadin">
			{block name="leadin"}{/block}
		</div>
	{/if}

	{block name="override_header"}{/block}

	{hook h='displayAdminListBefore'}

	{if isset($name_controller)}
		{capture name=hookName assign=hookName}display{$name_controller|ucfirst}ListBefore{/capture}
		{hook h=$hookName}
	{elseif isset($smarty.get.controller)}
		{capture name=hookName assign=hookName}display{$smarty.get.controller|ucfirst|htmlentities}ListBefore{/capture}
		{hook h=$hookName}
	{/if}

	<div class="alert alert-warning" id="{$list_id}-empty-filters-alert" style="display:none;">{l s='Please fill at least one field to perform a search in this list.' mod='bpostshm'}</div>

	{block name="startForm"}
		<form method="post" action="{$action|escape:'html':'UTF-8'}" class="form-horizontal clearfix" id="form-{$list_id}">
	{/block}

	{if !$simple_header}
		<input type="hidden" id="submitFilter{$list_id|escape}" name="submitFilter{$list_id|escape}" value="0"/>
		{block name="override_form_extra"}{/block}
		<div class="panel col-lg-12">
			<div class="panel-heading">
				{if isset($icon)}<i class="{$icon}"></i> {/if}{if is_array($title)}{$title|end}{else}{$title}{/if}
				{if isset($toolbar_btn) && count($toolbar_btn) >0}
					<span class="badge">{$list_total|intval}</span>
					<span class="panel-heading-action">
					{foreach from=$toolbar_btn item=btn key=k}
						{if $k != 'modules-list' && $k != 'back'}
							<a id="desc-{$table}-{if isset($btn.imgclass)}{$btn.imgclass}{else}{$k}{/if}" class="list-toolbar-btn"{if isset($btn.href)} href="{$btn.href|escape:'html':'UTF-8'}"{/if}{if isset($btn.target) && $btn.target} target="_blank"{/if}{if isset($btn.js) && $btn.js} onclick="{$btn.js}"{/if}>
								<span title="" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s=$btn.desc mod='bpostshm'}" data-html="true" data-placement="left">
									<i class="process-icon-{if isset($btn.imgclass)}{$btn.imgclass}{else}{$k}{/if}{if isset($btn.class)} {$btn.class}{/if}"></i>
								</span>
							</a>
						{/if}
					{/foreach}
						<a class="list-toolbar-btn" href="javascript:location.reload();">
							<span title="" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Refresh list' mod='bpostshm'}" data-html="true" data-placement="left">
								<i class="process-icon-refresh" ></i>
							</span>
						</a>
					</span>
				{/if}
			</div>
			{if $show_toolbar}
				<script type="text/javascript">
					//<![CDATA[
					var submited = false;
					$(function() {
						//get reference on save link
						btn_save = $('i[class~="process-icon-save"]').parent();
						//get reference on form submit button
						btn_submit = $('#{$table|escape}_form_submit_btn');
						if (btn_save.length > 0 && btn_submit.length > 0) {
							//get reference on save and stay link
							btn_save_and_stay = $('i[class~="process-icon-save-and-stay"]').parent();
							//get reference on current save link label
							lbl_save = $('#desc-{$table|escape}-save div');
							//override save link label with submit button value
							if (btn_submit.val().length > 0) {
								lbl_save.html(btn_submit.attr("value"));
							}
							if (btn_save_and_stay.length > 0) {
								//get reference on current save link label
								lbl_save_and_stay = $('#desc-{$table|escape}-save-and-stay div');
								//override save and stay link label with submit button value
								if (btn_submit.val().length > 0 && lbl_save_and_stay && !lbl_save_and_stay.hasClass('locked')) {
									lbl_save_and_stay.html(btn_submit.val() + " {l s='and stay' mod='bpostshm'} ");
								}
							}
							//hide standard submit button
							btn_submit.hide();
							//bind enter key press to validate form
							$('#{$table|escape}_form').keypress(function (e) {
								if (e.which == 13 && e.target.localName != 'textarea') {
									$('#desc-{$table|escape}-save').click();
								}
							});
							//submit the form
							{block name=formSubmit}
								btn_save.click(function() {
									// Avoid double click
									if (submited) {
										return false;
									}
									submited = true;
									//add hidden input to emulate submit button click when posting the form -> field name posted
									btn_submit.before('<input type="hidden" name="'+btn_submit.attr("name")+'" value="1" />');
									$('#{$table|escape}_form').submit();
									return false;
								});
								if (btn_save_and_stay) {
									btn_save_and_stay.click(function() {
										//add hidden input to emulate submit button click when posting the form -> field name posted
										btn_submit.before('<input type="hidden" name="'+btn_submit.attr("name")+'AndStay" value="1" />');
										$('#{$table|escape}_form').submit();
										return false;
									});
								}
							{/block}
						}
					});
					//]]>
				</script>
			{/if}
	{elseif $simple_header}
		<div class="panel col-lg-12">
			{if isset($title)}<h3>{if isset($icon)}<i class="{$icon}"></i> {/if}{if is_array($title)}{$title|end}{else}{$title}{/if}</h3>{/if}
	{/if}
		{block name="preTable"}{/block}
		<div class="table-responsive clearfix{if isset($use_overflow) && $use_overflow} overflow-y{/if} panel">
			<table{if $table_id} id="table-{$table_id}"{/if} class="table{if $table_dnd} tableDnD{/if} {$table}" >
				<thead>
					<tr class="nodrag nodrop">
						{if $bulk_actions && $has_bulk_actions}
							<th class="center fixed-width-xs"></th>
						{/if}
						{foreach $fields_display AS $key => $params}
						<th class="{if isset($params.class)}{$params.class}{/if}{if isset($params.align)} {$params.align}{/if}">
							<span class="title_box{if isset($order_by) && ($key == $order_by)} active{/if}">
								{if isset($params.hint)}
									<span class="label-tooltip" data-toggle="tooltip"
										title="
											{if is_array($params.hint)}
												{foreach $params.hint as $hint}
													{if is_array($hint)}
														{$hint.text|escape}
													{else}
														{$hint|escape}
													{/if}
												{/foreach}
											{else}
												{$params.hint|escape}
											{/if}
										">
										{$params.title|escape}
									</span>
								{else}
									{$params.title|escape}
								{/if}

								{if (!isset($params.orderby) || $params.orderby) && !$simple_header && $show_filters}
									<a {if isset($order_by) && ($key == $order_by) && ($order_way == 'DESC')}class="active"{/if}  href="{$current|escape:'html':'UTF-8'}&amp;{$list_id}Orderby={$key|urlencode}&amp;{$list_id}Orderway=desc&amp;token={$token|escape:'html':'UTF-8'}{if isset($smarty.get.$identifier)}&amp;{$identifier}={$smarty.get.$identifier|intval}{/if}">
										<i class="icon-caret-down"></i>
									</a>
									<a {if isset($order_by) && ($key == $order_by) && ($order_way == 'ASC')}class="active"{/if} href="{$current|escape:'html':'UTF-8'}&amp;{$list_id}Orderby={$key|urlencode}&amp;{$list_id}Orderway=asc&amp;token={$token|escape:'html':'UTF-8'}{if isset($smarty.get.$identifier)}&amp;{$identifier}={$smarty.get.$identifier|intval}{/if}">
										<i class="icon-caret-up"></i>
									</a>
								{/if}
							</span>
						</th>
						{/foreach}
						{if $shop_link_type}
							<th>
								<span class="title_box">
								{if $shop_link_type == 'shop'}
									{l s='Shop' mod='bpostshm'}
								{else}
									{l s='Shop group' mod='bpostshm'}
								{/if}
								</span>
							</th>
						{/if}
						{if $has_actions || $show_filters}
							<th>{if !$simple_header}{/if}</th>
						{/if}
					</tr>
				{if !$simple_header && $show_filters}
					<tr class="nodrag nodrop filter {if $row_hover}row_hover{/if}">
						{if $has_bulk_actions}
							<th class="text-center">
								--
							</th>
						{/if}
						{* Filters (input, select, date or bool) *}
						{foreach $fields_display AS $key => $params}
							<th {if isset($params.align)} class="{$params.align}" {/if}>
								{if isset($params.search) && !$params.search}
									--
								{else}
									{if $params.type == 'bool'}
										<select class="filter fixed-width-sm" name="{$list_id|escape}Filter_{$key|escape}">
											<option value="">-</option>
											<option value="1" {if $params.value == 1} selected="selected" {/if}>{l s='Yes' mod='bpostshm'}</option>
											<option value="0" {if $params.value == 0 && $params.value != ''} selected="selected" {/if}>{l s='No' mod='bpostshm'}</option>
										</select>
									{elseif $params.type == 'date' || $params.type == 'datetime'}
										<div class="date_range row">
											<div class="input-group fixed-width-md">
												<input type="text" class="filter datepicker date-input form-control" id="local_{$params.id_date|escape}_0" name="local_{$params.name_date|escape}[0]"  placeholder="{l s='From' mod='bpostshm'}" />
												<input type="hidden" id="{$params.id_date}_0" name="{$params.name_date}[0]" value="{if isset($params.value.0)}{$params.value.0}{/if}">
												<span class="input-group-addon">
													<i class="icon-calendar"></i>
												</span>
											</div>
											<div class="input-group fixed-width-md">
												<input type="text" class="filter datepicker date-input form-control" id="local_{$params.id_date|escape}_1" name="local_{$params.name_date|escape}[1]"  placeholder="{l s='To' mod='bpostshm'}" />
												<input type="hidden" id="{$params.id_date}_1" name="{$params.name_date}[1]" value="{if isset($params.value.1)}{$params.value.1}{/if}">
												<span class="input-group-addon">
													<i class="icon-calendar"></i>
												</span>
											</div>
											<script>
												$(function() {
													var dateStart = parseDate($("#{$params.id_date|escape}_0").val());
													var dateEnd = parseDate($("#{$params.id_date|escape}_1").val());
													$("#local_{$params.id_date|escape}_0").datepicker({
														altField: "#{$params.id_date|escape}_0"
													});
													$("#local_{$params.id_date|escape}_1").datepicker({
														altField: "#{$params.id_date|escape}_1"
													});
													if (dateStart !== null){
														$("#local_{$params.id_date|escape}_0").datepicker("setDate", dateStart);
													}
													if (dateEnd !== null){
														$("#local_{$params.id_date|escape}_1").datepicker("setDate", dateEnd);
													}
												});
											</script>
										</div>
									{elseif $params.type == 'select'}
										{if isset($params.filter_key)}
											<select class="filter" onchange="$('#submitFilterButton{$list_id}').focus();$('#submitFilterButton{$list_id}').click();" name="{$list_id}Filter_{$params.filter_key}" {if isset($params.width)} style="width:{$params.width}px"{/if}>
												<option value="" {if $params.value == ''} selected="selected" {/if}>-</option>
												{if isset($params.list) && is_array($params.list)}
													{foreach $params.list AS $option_value => $option_display}
														<option value="{$option_value}" {if (string)$option_display === (string)$params.value ||  (string)$option_value === (string)$params.value} selected="selected"{/if}>{$option_display}</option>
													{/foreach}
												{/if}
											</select>
										{/if}
									{else}
										<input type="text" class="filter" name="{$list_id}Filter_{if isset($params.filter_key)}{$params.filter_key}{else}{$key}{/if}" value="{$params.value|escape:'html':'UTF-8'}" {if isset($params.width) && $params.width != 'auto'} style="width:{$params.width}px"{/if} />
									{/if}
								{/if}
							</th>
						{/foreach}

						{if $shop_link_type}
							<th>--</th>
						{/if}
						{if $has_actions || $show_filters}
							<th class="actions">
								{if $show_filters}
								<span class="pull-right">
									{*Search must be before reset for default form submit*}
									<button type="submit" id="submitFilterButton{$list_id|escape}" name="submitFilter" class="btn btn-default" data-list-id="{$list_id|escape}">
										<i class="icon-search"></i> {l s='Search' mod='bpostshm'}
									</button>
									{if $filters_has_value}
										<button type="submit" name="submitReset{$list_id|escape}" class="btn btn-warning">
											<i class="icon-eraser"></i> {l s='Reset' mod='bpostshm'}
										</button>
									{/if}
								</span>
								{/if}
							</th>
						{/if}
					</tr>
				{/if}
				</thead>
{/if}