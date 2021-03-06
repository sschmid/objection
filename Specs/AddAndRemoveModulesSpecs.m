#import "SpecHelper.h"
#import "Fixtures.h"
#import "ModuleFixtures.h"


SPEC_BEGIN(AddAndRemoveModulesSpecs)
__block SecondModule *module = nil;
__block JSObjectionInjector *injector = nil;

beforeEach(^{
    module = [[[SecondModule alloc] init] autorelease];
    gEagerSingletonHook = NO;
    injector = [JSObjection createInjector:module];
});

it(@"builds a new injector with new modules", ^{
    assertThat([injector getObject:@protocol(GearBox)], is(instanceOf([AfterMarketGearBox class])));
    assertThat([injector getObject:[Car class]], isNot(instanceOf([ManualCar class])));    
    assertThatBool(gEagerSingletonHook, equalToBool(NO));
    
    injector = [injector withModules:
                    [[[ProviderModule alloc] init] autorelease],
                    [[[FirstModule alloc] init] autorelease], nil];

    assertThat([injector getObject:@protocol(GearBox)], is(instanceOf([AfterMarketGearBox class])));
    assertThat([injector getObject:[Car class]], is(instanceOf([ManualCar class])));
    assertThatBool(gEagerSingletonHook, equalToBool(YES));
});

it(@"builds a new module without the module types", ^{
    injector = [injector withModules:
                [[[ProviderModule alloc] init] autorelease], nil];

    assertThat([injector getObject:@protocol(GearBox)], is(instanceOf([AfterMarketGearBox class])));
    assertThat([injector getObject:[Car class]], is(instanceOf([ManualCar class])));

    injector = [injector withoutModuleOfTypes:[SecondModule class], [ProviderModule class], nil];
    
    assertThat([injector getObject:@protocol(GearBox)], is(nilValue()));
    assertThat([injector getObject:[Car class]], isNot(instanceOf([ManualCar class])));
});

SPEC_END