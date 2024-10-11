/****************************************************************************
** Meta object code from reading C++ file 'ImageProcessor.h'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.7.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../src/ImageProcessor.h"
#include <QtCore/qmetatype.h>
#include <QtCore/QList>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'ImageProcessor.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 68
#error "This file was generated using the moc from 6.7.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {

#ifdef QT_MOC_HAS_STRINGDATA
struct qt_meta_stringdata_CLASSImageProcessorENDCLASS_t {};
constexpr auto qt_meta_stringdata_CLASSImageProcessorENDCLASS = QtMocHelpers::stringData(
    "ImageProcessor",
    "heightCalculation",
    "",
    "result",
    "zoom",
    "ImageProcessor*",
    "colorSpace",
    "singleChannel",
    "typeConvert",
    "histogram",
    "binary",
    "contrastRatio",
    "filter",
    "localBinary",
    "stretch",
    "compress",
    "processAnswerSheet",
    "heightDetectionSystem",
    "set",
    "SignalListener*",
    "QList<int>"
);
#else  // !QT_MOC_HAS_STRINGDATA
#error "qtmochelpers.h not found or too old."
#endif // !QT_MOC_HAS_STRINGDATA
} // unnamed namespace

Q_CONSTINIT static const uint qt_meta_data_CLASSImageProcessorENDCLASS[] = {

 // content:
      12,       // revision
       0,       // classname
       0,    0, // classinfo
      15,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    1,  104,    2, 0x06,    1 /* Public */,

 // slots: name, argc, parameters, tag, flags, initial metatype offsets
       4,    0,  107,    2, 0x0a,    3 /* Public */,
       6,    0,  108,    2, 0x0a,    4 /* Public */,
       7,    0,  109,    2, 0x0a,    5 /* Public */,
       8,    0,  110,    2, 0x0a,    6 /* Public */,
       9,    0,  111,    2, 0x0a,    7 /* Public */,
      10,    0,  112,    2, 0x0a,    8 /* Public */,
      11,    0,  113,    2, 0x0a,    9 /* Public */,
      12,    0,  114,    2, 0x0a,   10 /* Public */,
      13,    0,  115,    2, 0x0a,   11 /* Public */,
      14,    0,  116,    2, 0x0a,   12 /* Public */,
      15,    0,  117,    2, 0x0a,   13 /* Public */,
      16,    0,  118,    2, 0x0a,   14 /* Public */,
      17,    0,  119,    2, 0x0a,   15 /* Public */,

 // methods: name, argc, parameters, tag, flags, initial metatype offsets
      18,   11,  120,    2, 0x02,   16 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QJsonObject,    3,

 // slots: parameters
    0x80000000 | 5,
    0x80000000 | 5,
    0x80000000 | 5,
    0x80000000 | 5,
    0x80000000 | 5,
    0x80000000 | 5,
    0x80000000 | 5,
    0x80000000 | 5,
    0x80000000 | 5,
    0x80000000 | 5,
    0x80000000 | 5,
    0x80000000 | 5,
    0x80000000 | 5,

 // methods: parameters
    0x80000000 | 5, 0x80000000 | 19, 0x80000000 | 20, QMetaType::QString, QMetaType::Double, QMetaType::Int, QMetaType::Int, QMetaType::Int, QMetaType::Int, QMetaType::Int, QMetaType::Int, QMetaType::Double,    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,

       0        // eod
};

Q_CONSTINIT const QMetaObject ImageProcessor::staticMetaObject = { {
    QMetaObject::SuperData::link<TaskBase::staticMetaObject>(),
    qt_meta_stringdata_CLASSImageProcessorENDCLASS.offsetsAndSizes,
    qt_meta_data_CLASSImageProcessorENDCLASS,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_stringdata_CLASSImageProcessorENDCLASS_t,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<ImageProcessor, std::true_type>,
        // method 'heightCalculation'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QJsonObject &, std::false_type>,
        // method 'zoom'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'colorSpace'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'singleChannel'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'typeConvert'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'histogram'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'binary'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'contrastRatio'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'filter'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'localBinary'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'stretch'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'compress'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'processAnswerSheet'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'heightDetectionSystem'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        // method 'set'
        QtPrivate::TypeAndForceComplete<ImageProcessor *, std::false_type>,
        QtPrivate::TypeAndForceComplete<SignalListener *, std::false_type>,
        QtPrivate::TypeAndForceComplete<QList<int>, std::false_type>,
        QtPrivate::TypeAndForceComplete<QString, std::false_type>,
        QtPrivate::TypeAndForceComplete<double, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<double, std::false_type>
    >,
    nullptr
} };

void ImageProcessor::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<ImageProcessor *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->heightCalculation((*reinterpret_cast< std::add_pointer_t<QJsonObject>>(_a[1]))); break;
        case 1: { ImageProcessor* _r = _t->zoom();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 2: { ImageProcessor* _r = _t->colorSpace();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 3: { ImageProcessor* _r = _t->singleChannel();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 4: { ImageProcessor* _r = _t->typeConvert();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 5: { ImageProcessor* _r = _t->histogram();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 6: { ImageProcessor* _r = _t->binary();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 7: { ImageProcessor* _r = _t->contrastRatio();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 8: { ImageProcessor* _r = _t->filter();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 9: { ImageProcessor* _r = _t->localBinary();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 10: { ImageProcessor* _r = _t->stretch();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 11: { ImageProcessor* _r = _t->compress();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 12: { ImageProcessor* _r = _t->processAnswerSheet();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 13: { ImageProcessor* _r = _t->heightDetectionSystem();
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        case 14: { ImageProcessor* _r = _t->set((*reinterpret_cast< std::add_pointer_t<SignalListener*>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QList<int>>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[3])),(*reinterpret_cast< std::add_pointer_t<double>>(_a[4])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[5])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[6])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[7])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[8])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[9])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[10])),(*reinterpret_cast< std::add_pointer_t<double>>(_a[11])));
            if (_a[0]) *reinterpret_cast< ImageProcessor**>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
        case 14:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 1:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QList<int> >(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< SignalListener* >(); break;
            }
            break;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (ImageProcessor::*)(const QJsonObject & );
            if (_t _q_method = &ImageProcessor::heightCalculation; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
    }
}

const QMetaObject *ImageProcessor::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ImageProcessor::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_CLASSImageProcessorENDCLASS.stringdata0))
        return static_cast<void*>(this);
    return TaskBase::qt_metacast(_clname);
}

int ImageProcessor::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = TaskBase::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 15)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 15;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 15)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 15;
    }
    return _id;
}

// SIGNAL 0
void ImageProcessor::heightCalculation(const QJsonObject & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_WARNING_POP
