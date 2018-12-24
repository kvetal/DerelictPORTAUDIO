module derelict.portaudio.libportaudio;

import core.stdc.config;
import derelict.util.exception,
		derelict.util.loader,
		derelict.util.system;

alias int PaError;
alias int PaDeviceIndex;
alias int PaHostApiIndex;
alias double PaTime;
alias void PaStream;


alias c_ulong PaSampleFormat;
alias  c_ulong  PaStreamFlags;
alias c_ulong  PaStreamCallbackFlags;


struct PaStreamCallbackTimeInfo
{
	PaTime inputBufferAdcTime;
	PaTime currenTime;
	PaTime outputBufferDacTime;
}

alias PaStreamCallback = int function(const void* input, void* output, ulong frameCount, const PaStreamCallbackTimeInfo* timeInfo, PaStreamCallbackFlags statusFlags, void* userData);
alias PaStreamFinishedCallback = void function(void* userData);

	
enum  PaErrorCode
{
	paNoError = 0, 
	paNotInitialized = -10000,
	paUnanticipatedHostError,
	paInvalidChannelCount,
	paInvalidSampleRate,
	paInvalidDevice,
	paInvalidFlag,
	paSampleFormatNotSupported,
	paBadIODeviceCombination,
	paInsufficientMemory,
	paBufferTooBig,
	paBufferTooSmall,
	paNullCallback,
	paBadStreamPtr,
	paTimedOut,
	paInternalError,
	paDeviceUnavailable,
	paIncompatibleHostApiSpecificStreamInfo,
	paStreamIsStopped,
	paStreamIsNotStopped,
	paInputOverflowed,
	paOutputUnderflowed,
	paHostApiNotFound,
	paInvalidHostApi,
	paCanNotReadFromACallbackStream,
	paCanNotWriteToACallbackStream,
	paCanNotReadFromAnOutputOnlyStream,
	paCanNotWriteToAnInputOnlyStream,
	paIncompatibleStreamHostApi,
	paBadBufferPtr
}

enum PaHostApiTypeId
{
	paInDevelopment=0,
	paDirectSound=1,
	paMME=2,
	paASIO=3,
	paSoundManager=4,
	paCoreAudio=5,
	paOSS=7,
	paALSA=8,
	paAL=9,
	paBeOS=10,
	paWDMKS=11,
	paJACK=12,
	paWASAPI=13,
	paAudioScienceHPI=14
}

struct PaHostApiInfo
{
	int structVersion;
	PaHostApiTypeId type;
	const (char*) name;
	int deviceCount;
	PaDeviceIndex defaultInputDevice;
	PaDeviceIndex defaultOutputDevice;
}

struct PaVersionInfo
{
	int versionMajor;
	int versionMinor;
	int versionSubMinor;
	const char* versionControlRevision;
	const char* versionText;
}

struct PaHostErrorInfo
{
	PaHostApiTypeId hostApiType;
	static if (long.sizeof == 4)
		long errorCode;
	else
		int errorCode;
	const (char*) errorText;
}

struct PaDeviceInfo
{
	int structVersion;
	const char* name;
	PaHostApiIndex hostApi;
	int maxInputChannels;
	int maxOutputChannels;
	PaTime defaultLowInputLatency;
	PaTime defaultLowOutputLatency;
	PaTime defaultHighInputLatency;
	PaTime defaultHighOutputLatency;
	double defaultSampleRate;
}

struct PaStreamParameters
{
	PaDeviceIndex device;
	int channelCount;
	PaSampleFormat sampleFormat;
	PaTime suggestedLatency;
	void *hostApiSpecificStreamInfo;
}

enum PaSampleFormat 
	paFloat32 = 0x00000001, 
	paInt32 = 0x00000002,
	paInt24 = 0x00000004,
	paInt16 = 0x00000008,
	paInt8 = 0x00000010,
	paUInt8 = 0x00000020,
	paCustomFormat = 0x00010000,
	paNonInterleaved = 0x80000000;

enum PaStreamFlags
	paNoFlag = 0,
	paClipOff = 0x00000001,
	paDitherOff = 0x00000002,
	paNeverDropInput = 0x00000004,
	paPrimeOutputBuffersUsingStreamCallback = 0x00000008,
	paPlatformSpecificFlags = 0xFFFF0000;

enum PaStreamCallbackFlags
	paInputUnderflow = 0x00000001,
	paInputOverflow = 0x00000002,
	paOutputUnderflow = 0x00000004,
	paOutputOverflow = 0x00000008,
	paPrimingOutput = 0x00000010;

enum PaStreamCallbackResult
{
	paContinue = 0,
	paComplete = 1,
	paAbort = 2
}

struct PaStreamInfo
{
	int structVersion;
	PaTime inputLatency;
	PaTime outputLatency;
	double sampleRate;
}

extern(C)
{
	alias da_Pa_Initialize = PaError function();
	alias da_Pa_Terminate = PaError function();
	alias da_Pa_GetVersion = int function();
	alias da_Pa_GetVersionText = const char* function();
	alias da_Pa_GetVersionInfo = const PaVersionInfo* function();
	alias da_Pa_GetErrorText = const char* function(PaError);
	alias da_Pa_GetHostApiCount = PaHostApiIndex function();
	alias da_Pa_GetDefaultHostApi = PaHostApiIndex function();
	alias da_Pa_GetHostApiInfo = const PaHostApiInfo* function(PaHostApiIndex);
	alias da_Pa_HostApiTypeIdToHostApiIndex = PaHostApiIndex function(PaHostApiTypeId);
	alias da_Pa_HostApiDeviceIndexToDeviceIndex = PaDeviceIndex function(PaHostApiIndex, int);
	alias da_Pa_GetLastHostErrorInfo = const PaHostErrorInfo* function();
	alias da_Pa_GetDeviceCount = PaDeviceIndex function();
	alias da_Pa_GetDefaultInputDevice = PaDeviceIndex function();
	alias da_Pa_GetDefaultOutputDevice = PaDeviceIndex function();
	alias da_Pa_GetDeviceInfo = const PaDeviceInfo* function(PaDeviceIndex);
	alias da_Pa_IsFormatSupported = PaError function(const PaStreamParameters*, const PaStreamParameters*, double);
	alias da_Pa_OpenStream	 = PaError function(PaStream**, const PaStreamParameters*, const PaStreamParameters*, double, ulong, PaStreamFlags, PaStreamCallback*, void* );
	alias da_Pa_OpenDefaultStream = PaError function(PaStream**, int, int, PaSampleFormat, double, c_ulong, PaStreamCallback*, void*);
	alias da_Pa_CloseStream =  PaError function(PaStream*);
	alias da_Pa_SetStreamFinishedCallback = PaError function(PaStream*, PaStreamFinishedCallback);
	alias da_Pa_StartStream  = PaError function(PaStream*);
	alias da_Pa_StopStream  = PaError function(PaStream*);
	alias da_Pa_AbortStream  = PaError function(PaStream*);
	alias da_Pa_IsStreamStopped  = PaError function(PaStream*);
	alias da_Pa_IsStreamActive = PaError function(PaStream*);
	alias da_Pa_GetStreamInfo = PaStreamInfo* function(PaStream*);
	alias da_Pa_GetStreamTime = PaTime function(PaStream*);
	alias da_Pa_GetStreamCpuLoad  = double function(PaStream*);
	alias da_Pa_ReadStream  = PaError function(PaStream*, void*, c_ulong);
	alias da_Pa_WriteStream = PaError function(PaStream*, const void*, c_ulong);
	alias da_Pa_GetStreamReadAvailable = c_ulong function(PaStream*);
	alias da_Pa_GetStreamWriteAvailable = c_ulong function(PaStream*);
	alias da_Pa_GetSampleSize = PaError function(PaSampleFormat);
	alias da_Pa_Sleep = void function(c_long);

}

__gshared {
		da_Pa_Initialize Pa_Initialize;
		da_Pa_Terminate Pa_Terminate;
		da_Pa_GetVersion Pa_GetVersion;
		da_Pa_GetVersionText Pa_GetVersionText;
		da_Pa_GetVersionInfo Pa_GetVersionInfo;
		da_Pa_GetErrorText Pa_GetErrorText;
		da_Pa_GetHostApiCount Pa_GetHostApiCount;
		da_Pa_GetDefaultHostApi Pa_GetDefaultHostApi;
		da_Pa_GetHostApiInfo Pa_GetHostApiInfo;
		da_Pa_HostApiTypeIdToHostApiIndex Pa_HostApiTypeIdToHostApiIndex;
		da_Pa_HostApiDeviceIndexToDeviceIndex Pa_HostApiDeviceIndexToDeviceIndex;
		da_Pa_GetLastHostErrorInfo Pa_GetLastHostErrorInfo;
		da_Pa_GetDeviceCount Pa_GetDeviceCount;
		da_Pa_GetDefaultInputDevice Pa_GetDefaultInputDevice;
		da_Pa_GetDefaultOutputDevice Pa_GetDefaultOutputDevice;
		da_Pa_GetDeviceInfo Pa_GetDeviceInfo;
		da_Pa_IsFormatSupported Pa_IsFormatSupported;
		da_Pa_OpenStream Pa_OpenStream;
		da_Pa_OpenDefaultStream Pa_OpenDefaultStream;
		da_Pa_CloseStream Pa_CloseStream;
		da_Pa_SetStreamFinishedCallback Pa_SetStreamFinishedCallback;
		da_Pa_StartStream  Pa_StartStream;
		da_Pa_StopStream  Pa_StopStream;
		da_Pa_AbortStream  Pa_AbortStream;
		da_Pa_IsStreamStopped  Pa_IsStreamStopped;
		da_Pa_IsStreamActive  Pa_IsStreamActive;
		da_Pa_GetStreamInfo Pa_GetStreamInfo;
		da_Pa_GetStreamTime Pa_GetStreamTime;
		da_Pa_GetStreamCpuLoad Pa_GetStreamCpuLoad;
		da_Pa_ReadStream Pa_ReadStream;
		da_Pa_WriteStream Pa_WriteStream;
		da_Pa_GetStreamReadAvailable Pa_GetStreamReadAvailable;
		da_Pa_GetStreamWriteAvailable Pa_GetStreamWriteAvailable;
		da_Pa_GetSampleSize Pa_GetSampleSize;
		da_Pa_Sleep Pa_Sleep;
}

class  DerelictPORTAUDIOLoader : SharedLibLoader {
	this() 
	{
		super(libNames);
	}


    protected override void loadSymbols()
    {
        bindFunc(cast(void**)&Pa_Initialize, "Pa_Initialize");
		bindFunc(cast(void**)&Pa_Terminate, "Pa_Terminate");
		bindFunc(cast(void**)&Pa_GetVersion, "Pa_GetVersion");
		bindFunc(cast(void**)&Pa_GetVersionText, "Pa_GetVersionText");
		bindFunc(cast(void**)&Pa_GetVersionInfo, "Pa_GetVersionInfo");
		bindFunc(cast(void**)&Pa_GetErrorText, "Pa_GetErrorText");
		bindFunc(cast(void**)&Pa_GetHostApiCount, "Pa_GetHostApiCount");
		bindFunc(cast(void**)&Pa_GetDefaultHostApi, "Pa_GetDefaultHostApi");
		bindFunc(cast(void**)&Pa_GetHostApiInfo, "Pa_GetHostApiInfo");
		bindFunc(cast(void**)&Pa_HostApiTypeIdToHostApiIndex, "Pa_HostApiTypeIdToHostApiIndex");
		bindFunc(cast(void**)&Pa_HostApiDeviceIndexToDeviceIndex, "Pa_HostApiDeviceIndexToDeviceIndex");
		bindFunc(cast(void**)&Pa_GetLastHostErrorInfo, "Pa_GetLastHostErrorInfo");
		bindFunc(cast(void**)&Pa_GetDeviceCount, "Pa_GetDeviceCount");
		bindFunc(cast(void**)&Pa_GetDefaultInputDevice, "Pa_GetDefaultInputDevice");
		bindFunc(cast(void**)&Pa_GetDefaultOutputDevice, "Pa_GetDefaultOutputDevice");
		bindFunc(cast(void**)&Pa_GetDeviceInfo, "Pa_GetDeviceInfo");
		bindFunc(cast(void**)&Pa_IsFormatSupported, "Pa_IsFormatSupported");
		bindFunc(cast(void**)&Pa_OpenStream, "Pa_OpenStream");
		bindFunc(cast(void**)&Pa_OpenDefaultStream, "Pa_OpenDefaultStream");
		bindFunc(cast(void**)&Pa_CloseStream, "Pa_CloseStream");
		bindFunc(cast(void**)&Pa_SetStreamFinishedCallback, "Pa_SetStreamFinishedCallback");
		bindFunc(cast(void**)&Pa_StartStream, "Pa_StartStream");
		bindFunc(cast(void**)&Pa_StopStream, "Pa_StopStream");
		bindFunc(cast(void**)&Pa_AbortStream, "Pa_AbortStream");
		bindFunc(cast(void**)&Pa_IsStreamStopped, "Pa_IsStreamStopped");
		bindFunc(cast(void**)&Pa_IsStreamActive, "Pa_IsStreamActive");
		bindFunc(cast(void**)&Pa_GetStreamInfo, "Pa_GetStreamInfo");
		bindFunc(cast(void**)&Pa_GetStreamTime, "Pa_GetStreamTime");
		bindFunc(cast(void**)&Pa_GetStreamCpuLoad, "Pa_GetStreamCpuLoad");
		bindFunc(cast(void**)&Pa_ReadStream, "Pa_ReadStream");
		bindFunc(cast(void**)&Pa_WriteStream, "Pa_WriteStream");
		bindFunc(cast(void**)&Pa_GetStreamReadAvailable, "Pa_GetStreamReadAvailable");
		bindFunc(cast(void**)&Pa_GetStreamWriteAvailable, "Pa_GetStreamWriteAvailable");
		bindFunc(cast(void**)&Pa_GetSampleSize, "Pa_GetSampleSize");
		bindFunc(cast(void**)&Pa_Sleep, "Pa_Sleep");
	}
}

__gshared DerelictPORTAUDIOLoader DerelictPORTAUDIO;

shared static this() 
{
    DerelictPORTAUDIO = new DerelictPORTAUDIOLoader();
}

private
{
    static if(Derelict_OS_Windows)
        enum libNames = "libportaudio32bit.dll";
    else static if(Derelict_OS_Linux)
        enum libNames = "libportaudio.so";
    else
        static assert(0, "add libportaudio file name");
}
