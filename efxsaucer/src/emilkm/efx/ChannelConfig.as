/**
 * efx (http://emilmalinov.com/efx)
 *
 * @copyright Copyright (c) 2015 Emil Malinov
 * @license   http://www.apache.org/licenses/LICENSE-2.0 Apache License 2.0
 * @link      http://github.com/emilkm/efx
 * @package   efx
 */

package emilkm.efx
{
import emilkm.efxphp.Response;

import flash.net.registerClassAlias;

import mx.core.Application;
import mx.messaging.Channel;
import mx.messaging.ChannelSet;
import mx.messaging.config.ServerConfig;
import mx.messaging.events.ChannelEvent;
import mx.messaging.events.ChannelFaultEvent;

public class ChannelConfig
{
	public static const DEFAULT_CHANNEL_ID:String = 'efx';
	public static const SECURE_CHANNEL_ID:String = 's_efx';
	public static const DEFAULT_DESTINATION_ID:String = 'efxphp';
	public static const SECURE_DESTINATION_ID:String = 's_efxphp';
	
	private var _endpoint:String;
	private var _connectTimeout:int = -1;
	private var _requestTimeout:int = -1;
	private var _dualChannel:Boolean = false;
	private var _sidPropagation:String = 'header';
	
	public var channelSet:ChannelSet;
	public var channel:Channel;
	public var s_channelSet:ChannelSet;
	public var s_channel:Channel;
	
	private var _sid:String = null;
	
	/**
	 * dualChannel: false = default (HTTP), or secure (HTTPS), depending on endpoint protocol, true = dual channel (HTTP and HTTPS)
	 * sidPropagation: 'header' = through AMF RemoteMessage header sID, 'query' = through query string sID
	 */
	public function ChannelConfig(
		endpoint:String = '',
		connectTimeout:int = -1,
		requestTimeout:int = -1,
		dualChannel:Boolean = false,
		sidPropagation:String = 'header'
	) {
		registerClassAlias('emilkm.efxphp.Response', Response);
		
		_dualChannel = dualChannel;
		
		if (sidPropagation != 'header' && sidPropagation != 'query')
			throw new Error("sidPropagation: 'header' = through AMF RemoteMessage header sID, 'query' = through query string sID");
		_sidPropagation = sidPropagation;
		
		if (endpoint != '')
		{
			_endpoint = endpoint;
			this.configure(_endpoint);
		}
	}
	
	private function channelFault(event:ChannelFaultEvent):void
	{
		trace(event);
	}
	
	public function get sid():String
	{
		return _sid;
	}
	
	public function set sid(value:String):void
	{
		_sid = value;
		
		if (_sidPropagation == 'header')
		{
			if (channel is AMFChannel)
				(channel as AMFChannel).headers['sID'] = _sid;
			if (s_channel is AMFChannel)
				(s_channel as AMFChannel).headers['sID'] = _sid;
		}
		else
		{
			if (channel is AMFChannel)
				(channel as AMFChannel).AppendToGatewayUrl(value);
			if (s_channel is AMFChannel)
				(s_channel as AMFChannel).AppendToGatewayUrl(value);
		}
	}
	
	public function appendToGatewayUrl(value:String):void
	{
		if (channel is AMFChannel)
			(channel as AMFChannel).AppendToGatewayUrl(value);
		if (s_channel is AMFChannel)
			(s_channel as AMFChannel).AppendToGatewayUrl(value);
	}
	
	public function configure(endpoint:String = ''):void
	{
		if (_endpoint != endpoint && endpoint != '')
			_endpoint = endpoint;
		
		var uri:String = _endpoint;
		
		var sericesConfig:XML;
		if (_dualChannel)
		{
			sericesConfig =
				<services-config>
					<services>
						<service id="amfphp-flashremoting-service" class="mx.messaging.services.RemotingService" messageTypes="mx.messaging.messages.RemotingMessage">
							<destination id={DEFAULT_DESTINATION_ID}>
								<channels>
									<channel ref={DEFAULT_CHANNEL_ID}/>
								</channels>
								<properties>
									<source>*</source>
								</properties>
							</destination>
							<destination id={SECURE_DESTINATION_ID}>
								<channels>
									<channel ref={SECURE_CHANNEL_ID}/>
								</channels>
								<properties>
									<source>*</source>
								</properties>
							</destination>
						</service>
					</services>
					<channels>
						<channel id={DEFAULT_CHANNEL_ID} type="emilkm.efx.AMFChannel">
							<endpoint uri={uri.replace('https:','http:')}/>
							<properties/>
						</channel>
						<channel id={SECURE_CHANNEL_ID} type="emilkm.efx.SecureAMFChannel">
							<endpoint uri={uri.replace('http:','https:')}/>
							<properties/>
						</channel>
					</channels>
				</services-config>;
			
			ServerConfig.xml = sericesConfig;
			
			channelSet = ServerConfig.getChannelSet(DEFAULT_DESTINATION_ID);	
			channel = ServerConfig.getChannel(DEFAULT_CHANNEL_ID);
			channel.connectTimeout = this._connectTimeout;
			channel.requestTimeout = this._requestTimeout;
			
			s_channelSet = ServerConfig.getChannelSet(SECURE_DESTINATION_ID);	
			s_channel = ServerConfig.getChannel(SECURE_CHANNEL_ID);
			s_channel.connectTimeout = this._connectTimeout;
			s_channel.requestTimeout = this._requestTimeout;
		}
		else
		{
			var destinationId:String = '';
			var channelType:String = '';
			var channelId:String = '';
			
			
			
			if (uri.indexOf('https') == 0) 
			{
				destinationId = SECURE_DESTINATION_ID;
				channelType = 'emilkm.efx.SecureAMFChannel';
				channelId = SECURE_CHANNEL_ID;
			}
			else
			{
				destinationId = DEFAULT_DESTINATION_ID;
				channelType = 'emilkm.efx.AMFChannel';
				channelId = DEFAULT_CHANNEL_ID;
			}
			
			sericesConfig =
				<services-config>
					<services>
						<service id="amfphp-flashremoting-service" class="mx.messaging.services.RemotingService" messageTypes="mx.messaging.messages.RemotingMessage">
							<destination id={destinationId}>
								<channels>
									<channel ref={channelId}/>
								</channels>
								<properties>
									<source>*</source>
								</properties>
							</destination>
						</service>
					</services>
					<channels>
						<channel id="efx" type={channelType}>
							<endpoint uri={uri}/>
							<properties/>
						</channel>
					</channels>
				</services-config>;
			
			ServerConfig.xml = sericesConfig;
			
			channelSet = ServerConfig.getChannelSet(destinationId);	
			channel = ServerConfig.getChannel(channelId);
			channel.connectTimeout = this._connectTimeout;
			channel.requestTimeout = this._requestTimeout;
		}
	}
}
	
}